Qwen/Qwen3.5-9B · Hugging Face

[ Hugging Face](/)

- [ Models ](/models)
- [ Datasets ](/datasets)
- [ Spaces ](/spaces)
- [ Buckets new](/storage)
- [ Docs ](/docs)
- [ Enterprise ](/enterprise)
- [Pricing](/pricing)
- Website
[ Tasks](/tasks)
- [ HuggingChat](/chat)
- [ Collections](/collections)
- [ Languages](/languages)
- [ Organizations](/organizations)

- Community
[ Blog](/blog)
- [ Posts](/posts)
- [ Daily Papers](/papers)
- [ Hardware](/hardware)
- [ Learn](/learn)
- [ Discord](/join/discord)
- [ Forum](https://discuss.huggingface.co/)
- [ GitHub](https://github.com/huggingface)

- Solutions
[ Team & Enterprise](/enterprise)
- [ Hugging Face PRO](/pro)
- [ Enterprise Support](/support)
- [ Inference Providers](/inference/models)
- [ Inference Endpoints](/inference-endpoints)
- [ Storage Buckets](/storage)

-
- [Log In](/login)
- [Sign Up](/join)

<|image_pad|><|vision_end|>' }}\n {%- elif 'video' in item or item.type == 'video' %}\n {%- if is_system_content %}\n {{- raise_exception('System message cannot contain videos.') }}\n {%- endif %}\n {%- if do_vision_count %}\n {%- set video_count.value = video_count.value + 1 %}\n {%- endif %}\n {%- if add_vision_id %}\n {{- 'Video ' ~ video_count.value ~ ': ' }}\n {%- endif %}\n {{- '<|vision_start|><|video_pad|><|vision_end|>' }}\n {%- elif 'text' in item %}\n {{- item.text }}\n {%- else %}\n {{- raise_exception('Unexpected item type in content.') }}\n {%- endif %}\n {%- endfor %}\n {%- elif content is none or content is undefined %}\n {{- '' }}\n {%- else %}\n {{- raise_exception('Unexpected content type.') }}\n {%- endif %}\n{%- endmacro %}\n{%- if not messages %}\n {{- raise_exception('No messages provided.') }}\n{%- endif %}\n{%- if tools and tools is iterable and tools is not mapping %}\n {{- '<|im_start|>system\\n' }}\n {{- \"# Tools\\n\\nYou have access to the following functions:\\n\\n<tools>\" }}\n {%- for tool in tools %}\n {{- \"\\n\" }}\n {{- tool | tojson }}\n {%- endfor %}\n {{- \"\\n</tools>\" }}\n {{- '\\n\\nIf you choose to call a function ONLY reply in the following format with NO suffix:\\n\\n<tool_call>\\n<function=example_function_name>\\n<parameter=example_parameter_1>\\nvalue_1\\n</parameter>\\n<parameter=example_parameter_2>\\nThis is the value for the second parameter\\nthat can span\\nmultiple lines\\n</parameter>\\n</function>\\n</tool_call>\\n\\n<IMPORTANT>\\nReminder:\\n- Function calls MUST follow the specified format: an inner <function=...></function> block must be nested within <tool_call></tool_call> XML tags\\n- Required parameters MUST be specified\\n- You may provide optional reasoning for your function call in natural language BEFORE the function call, but NOT after\\n- If there is no function call available, answer the question like normal with your current knowledge and do not tell the user about function calls\\n</IMPORTANT>' }}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {%- if content %}\n {{- '\\n\\n' + content }}\n {%- endif %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n{%- else %}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {{- '<|im_start|>system\\n' + content + '<|im_end|>\\n' }}\n {%- endif %}\n{%- endif %}\n{%- set ns = namespace(multi_step_tool=true, last_query_index=messages|length - 1) %}\n{%- for message in messages[::-1] %}\n {%- set index = (messages|length - 1) - loop.index0 %}\n {%- if ns.multi_step_tool and message.role == \"user\" %}\n {%- set content = render_content(message.content, false)|trim %}\n {%- if not(content.startswith('<tool_response>') and content.endswith('</tool_response>')) %}\n {%- set ns.multi_step_tool = false %}\n {%- set ns.last_query_index = index %}\n {%- endif %}\n {%- endif %}\n{%- endfor %}\n{%- if ns.multi_step_tool %}\n {{- raise_exception('No user query found in messages.') }}\n{%- endif %}\n{%- for message in messages %}\n {%- set content = render_content(message.content, true)|trim %}\n {%- if message.role == \"system\" %}\n {%- if not loop.first %}\n {{- raise_exception('System message must be at the beginning.') }}\n {%- endif %}\n {%- elif message.role == \"user\" %}\n {{- '<|im_start|>' + message.role + '\\n' + content + '<|im_end|>' + '\\n' }}\n {%- elif message.role == \"assistant\" %}\n {%- set reasoning_content = '' %}\n {%- if message.reasoning_content is string %}\n {%- set reasoning_content = message.reasoning_content %}\n {%- else %}\n {%- if '</think>' in content %}\n {%- set reasoning_content = content.split('</think>')[0].rstrip('\\n').split('<think>')[-1].lstrip('\\n') %}\n {%- set content = content.split('</think>')[-1].lstrip('\\n') %}\n {%- endif %}\n {%- endif %}\n {%- set reasoning_content = reasoning_content|trim %}\n {%- if loop.index0 > ns.last_query_index %}\n {{- '<|im_start|>' + message.role + '\\n<think>\\n' + reasoning_content + '\\n</think>\\n\\n' + content }}\n {%- else %}\n {{- '<|im_start|>' + message.role + '\\n' + content }}\n {%- endif %}\n {%- if message.tool_calls and message.tool_calls is iterable and message.tool_calls is not mapping %}\n {%- for tool_call in message.tool_calls %}\n {%- if tool_call.function is defined %}\n {%- set tool_call = tool_call.function %}\n {%- endif %}\n {%- if loop.first %}\n {%- if content|trim %}\n {{- '\\n\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- else %}\n {{- '<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- else %}\n {{- '\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- if tool_call.arguments is defined %}\n {%- for args_name, args_value in tool_call.arguments|items %}\n {{- '<parameter=' + args_name + '>\\n' }}\n {%- set args_value = args_value | tojson | safe if args_value is mapping or (args_value is sequence and args_value is not string) else args_value | string %}\n {{- args_value }}\n {{- '\\n</parameter>\\n' }}\n {%- endfor %}\n {%- endif %}\n {{- '</function>\\n</tool_call>' }}\n {%- endfor %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n {%- elif message.role == \"tool\" %}\n {%- if loop.previtem and loop.previtem.role != \"tool\" %}\n {{- '<|im_start|>user' }}\n {%- endif %}\n {{- '\\n<tool_response>\\n' }}\n {{- content }}\n {{- '\\n</tool_response>' }}\n {%- if not loop.last and loop.nextitem.role != \"tool\" %}\n {{- '<|im_end|>\\n' }}\n {%- elif loop.last %}\n {{- '<|im_end|>\\n' }}\n {%- endif %}\n {%- else %}\n {{- raise_exception('Unexpected message role.') }}\n {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n {{- '<|im_start|>assistant\\n' }}\n {%- if enable_thinking is defined and enable_thinking is false %}\n {{- '<think>\\n\\n</think>\\n\\n' }}\n {%- else %}\n {{- '<think>\\n' }}\n {%- endif %}\n{%- endif %}","eos_token":"<|im_end|>","pad_token":"<|endoftext|>","unk_token":null},"chat_template_jinja":"{%- set image_count = namespace(value=0) %}\n{%- set video_count = namespace(value=0) %}\n{%- macro render_content(content, do_vision_count, is_system_content=false) %}\n {%- if content is string %}\n {{- content }}\n {%- elif content is iterable and content is not mapping %}\n {%- for item in content %}\n {%- if 'image' in item or 'image_url' in item or item.type == 'image' %}\n {%- if is_system_content %}\n {{- raise_exception('System message cannot contain images.') }}\n {%- endif %}\n {%- if do_vision_count %}\n {%- set image_count.value = image_count.value + 1 %}\n {%- endif %}\n {%- if add_vision_id %}\n {{- 'Picture ' ~ image_count.value ~ ': ' }}\n {%- endif %}\n {{- '<|vision_start|><|image_pad|><|vision_end|>' }}\n {%- elif 'video' in item or item.type == 'video' %}\n {%- if is_system_content %}\n {{- raise_exception('System message cannot contain videos.') }}\n {%- endif %}\n {%- if do_vision_count %}\n {%- set video_count.value = video_count.value + 1 %}\n {%- endif %}\n {%- if add_vision_id %}\n {{- 'Video ' ~ video_count.value ~ ': ' }}\n {%- endif %}\n {{- '<|vision_start|><|video_pad|><|vision_end|>' }}\n {%- elif 'text' in item %}\n {{- item.text }}\n {%- else %}\n {{- raise_exception('Unexpected item type in content.') }}\n {%- endif %}\n {%- endfor %}\n {%- elif content is none or content is undefined %}\n {{- '' }}\n {%- else %}\n {{- raise_exception('Unexpected content type.') }}\n {%- endif %}\n{%- endmacro %}\n{%- if not messages %}\n {{- raise_exception('No messages provided.') }}\n{%- endif %}\n{%- if tools and tools is iterable and tools is not mapping %}\n {{- '<|im_start|>system\\n' }}\n {{- \"# Tools\\n\\nYou have access to the following functions:\\n\\n<tools>\" }}\n {%- for tool in tools %}\n {{- \"\\n\" }}\n {{- tool | tojson }}\n {%- endfor %}\n {{- \"\\n</tools>\" }}\n {{- '\\n\\nIf you choose to call a function ONLY reply in the following format with NO suffix:\\n\\n<tool_call>\\n<function=example_function_name>\\n<parameter=example_parameter_1>\\nvalue_1\\n</parameter>\\n<parameter=example_parameter_2>\\nThis is the value for the second parameter\\nthat can span\\nmultiple lines\\n</parameter>\\n</function>\\n</tool_call>\\n\\n<IMPORTANT>\\nReminder:\\n- Function calls MUST follow the specified format: an inner <function=...></function> block must be nested within <tool_call></tool_call> XML tags\\n- Required parameters MUST be specified\\n- You may provide optional reasoning for your function call in natural language BEFORE the function call, but NOT after\\n- If there is no function call available, answer the question like normal with your current knowledge and do not tell the user about function calls\\n</IMPORTANT>' }}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {%- if content %}\n {{- '\\n\\n' + content }}\n {%- endif %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n{%- else %}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {{- '<|im_start|>system\\n' + content + '<|im_end|>\\n' }}\n {%- endif %}\n{%- endif %}\n{%- set ns = namespace(multi_step_tool=true, last_query_index=messages|length - 1) %}\n{%- for message in messages[::-1] %}\n {%- set index = (messages|length - 1) - loop.index0 %}\n {%- if ns.multi_step_tool and message.role == \"user\" %}\n {%- set content = render_content(message.content, false)|trim %}\n {%- if not(content.startswith('<tool_response>') and content.endswith('</tool_response>')) %}\n {%- set ns.multi_step_tool = false %}\n {%- set ns.last_query_index = index %}\n {%- endif %}\n {%- endif %}\n{%- endfor %}\n{%- if ns.multi_step_tool %}\n {{- raise_exception('No user query found in messages.') }}\n{%- endif %}\n{%- for message in messages %}\n {%- set content = render_content(message.content, true)|trim %}\n {%- if message.role == \"system\" %}\n {%- if not loop.first %}\n {{- raise_exception('System message must be at the beginning.') }}\n {%- endif %}\n {%- elif message.role == \"user\" %}\n {{- '<|im_start|>' + message.role + '\\n' + content + '<|im_end|>' + '\\n' }}\n {%- elif message.role == \"assistant\" %}\n {%- set reasoning_content = '' %}\n {%- if message.reasoning_content is string %}\n {%- set reasoning_content = message.reasoning_content %}\n {%- else %}\n {%- if '</think>' in content %}\n {%- set reasoning_content = content.split('</think>')[0].rstrip('\\n').split('<think>')[-1].lstrip('\\n') %}\n {%- set content = content.split('</think>')[-1].lstrip('\\n') %}\n {%- endif %}\n {%- endif %}\n {%- set reasoning_content = reasoning_content|trim %}\n {%- if loop.index0 > ns.last_query_index %}\n {{- '<|im_start|>' + message.role + '\\n<think>\\n' + reasoning_content + '\\n</think>\\n\\n' + content }}\n {%- else %}\n {{- '<|im_start|>' + message.role + '\\n' + content }}\n {%- endif %}\n {%- if message.tool_calls and message.tool_calls is iterable and message.tool_calls is not mapping %}\n {%- for tool_call in message.tool_calls %}\n {%- if tool_call.function is defined %}\n {%- set tool_call = tool_call.function %}\n {%- endif %}\n {%- if loop.first %}\n {%- if content|trim %}\n {{- '\\n\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- else %}\n {{- '<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- else %}\n {{- '\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- if tool_call.arguments is defined %}\n {%- for args_name, args_value in tool_call.arguments|items %}\n {{- '<parameter=' + args_name + '>\\n' }}\n {%- set args_value = args_value | tojson | safe if args_value is mapping or (args_value is sequence and args_value is not string) else args_value | string %}\n {{- args_value }}\n {{- '\\n</parameter>\\n' }}\n {%- endfor %}\n {%- endif %}\n {{- '</function>\\n</tool_call>' }}\n {%- endfor %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n {%- elif message.role == \"tool\" %}\n {%- if loop.previtem and loop.previtem.role != \"tool\" %}\n {{- '<|im_start|>user' }}\n {%- endif %}\n {{- '\\n<tool_response>\\n' }}\n {{- content }}\n {{- '\\n</tool_response>' }}\n {%- if not loop.last and loop.nextitem.role != \"tool\" %}\n {{- '<|im_end|>\\n' }}\n {%- elif loop.last %}\n {{- '<|im_end|>\\n' }}\n {%- endif %}\n {%- else %}\n {{- raise_exception('Unexpected message role.') }}\n {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n {{- '<|im_start|>assistant\\n' }}\n {%- if enable_thinking is defined and enable_thinking is false %}\n {{- '<think>\\n\\n</think>\\n\\n' }}\n {%- else %}\n {{- '<think>\\n' }}\n {%- endif %}\n{%- endif %}"},"createdAt":"2026-02-27T12:58:26.000Z","discussionsDisabled":false,"discussionsSorting":"recently-created","downloads":13442398,"downloadsAllTime":55389227,"id":"Qwen/Qwen3.5-9B","isLikedByUser":false,"availableInferenceProviders":[{"provider":"together","modelStatus":"live","providerStatus":"live","providerId":"Qwen/Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","features":{"structuredOutput":true,"toolCalling":true},"isCheapestPricingOutput":false,"isFastestThroughput":true,"isModelAuthor":false,"tokensPerSecond":101.44551625043732,"pricingOutput":0.25},{"provider":"ovhcloud","modelStatus":"live","providerStatus":"live","providerId":"Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","features":{"structuredOutput":true,"toolCalling":true},"isCheapestPricingOutput":false,"isFastestThroughput":false,"isModelAuthor":false,"tokensPerSecond":35.13790098107555,"pricingOutput":0.18},{"provider":"featherless-ai","modelStatus":"live","providerStatus":"live","providerId":"Qwen/Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","isCheapestPricingOutput":false,"isFastestThroughput":false,"isModelAuthor":false},{"provider":"deepinfra","modelStatus":"live","providerStatus":"live","providerId":"Qwen/Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","features":{"structuredOutput":true,"toolCalling":true},"isCheapestPricingOutput":true,"isFastestThroughput":false,"isModelAuthor":false,"tokensPerSecond":42.263940109119496,"pricingOutput":0.15}],"showHuggingChatEntry":true,"inference":"warm","lastModified":"2026-03-02T00:51:43.000Z","likes":1860,"pipeline_tag":"image-text-to-text","library_name":"transformers","librariesOther":[],"trackDownloads":true,"model-index":null,"evalResults":[{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"mean"},"value":86.1,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Mean","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"short"},"value":92.31,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Short","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"medium"},"value":81.12,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Medium","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"long"},"value":32.22,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Long","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"Idavidrein/gpqa","isBenchmark":true,"task_id":"diamond"},"value":81.7,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false,"author":{"_id":"63e0eea7af523c37e5a77966","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/1678663263366-63e0eea7af523c37e5a77966.jpeg","fullname":"Nathan Habib","name":"SaylorTwift","type":"user","isPro":true,"isHf":true,"isHfAdmin":false,"isMod":false,"followerCount":466,"isUserFollowing":false}},"filename":".eval_results/gpqa.yaml","verified":false,"pullRequest":2,"label":"Diamond"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"overall"},"value":65.7,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Overall"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"digital"},"value":74.8,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Digital"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"photographed"},"value":62.7,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Photographed"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"latin"},"value":72.5,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Latin"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"de"},"value":72.8,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"De"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"en"},"value":72,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"En"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"es"},"value":72,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Es"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"fr"},"value":64.4,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Fr"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"id"},"value":66.2,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Id"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"it"},"value":77.6,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"It"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"nl"},"value":74.5,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Nl"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"pt"},"value":79.1,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Pt"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"vi"},"value":74,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Vi"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"non_latin"},"value":58.2,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Non Latin"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"ar"},"value":53.4,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Ar"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"hi"},"value":56.2,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Hi"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"jp"},"value":55.7,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Jp"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"ko"},"value":60.3,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Ko"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"ru"},"value":54.7,"source":{"url":"https://huggingfa","isExternal":true},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Ru"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"mean"},"value":31.9,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Mean","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"text_content"},"value":90.5,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Text Content","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"text_formatting"},"value":22,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Text Formatting","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"layout"},"value":31.8,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Layout","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"chart"},"value":5.4,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Chart","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"table"},"value":9.9,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Table","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"TIGER-Lab/MMLU-Pro","isBenchmark":true,"task_id":"mmlu_pro"},"value":82.5,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false,"author":{"_id":"63e0eea7af523c37e5a77966","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/1678663263366-63e0eea7af523c37e5a77966.jpeg","fullname":"Nathan Habib","name":"SaylorTwift","type":"user","isPro":true,"isHf":true,"isHfAdmin":false,"isMod":false,"followerCount":466,"isUserFollowing":false}},"filename":".eval_results/mmlu_pro.yaml","verified":false,"pullRequest":2,"label":"Mmlu Pro"},{"dataset":{"id":"MMMU/MMMU_Pro","isBenchmark":true,"task_id":"mmmu_pro_vision"},"value":70.1,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false},"filename":".eval_results/mmmu_pro.yaml","verified":false,"pullRequest":55,"label":"Mmmu Pro Vision"},{"dataset":{"id":"likaixin/ScreenSpot-Pro","isBenchmark":true,"task_id":"overall"},"value":65.2,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false,"author":{"_id":"6141a88b3a0ec78603c9e784","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6141a88b3a0ec78603c9e784/DJsxSmWV39M33JFheLobC.jpeg","fullname":"merve","name":"merve","type":"user","isPro":true,"isHf":true,"isHfAdmin":false,"isMod":false,"followerCount":10731,"isUserFollowing":false}},"filename":".eval_results/screenspot_pro.yaml","verified":false,"pullRequest":37,"label":"Overall"},{"dataset":{"id":"MathArena/hmmt_feb_2026","isBenchmark":true,"task_id":"MathArena/hmmt_feb_2026"},"value":71.21,"source":{"url":"https://matharena.ai/?comp=hmmt--hmmt_feb_2026","name":"Official MathArena Evaluation","isExternal":true},"filename":".eval_results/MathArena--hmmt_feb_2026.yaml","verified":false,"pullRequest":36,"label":"MathArena Hmmt Feb 2026"},{"dataset":{"id":"MathArena/aime_2026","isBenchmark":true,"task_id":"MathArena/aime_2026"},"value":92.5,"source":{"url":"https://matharena.ai/?comp=aime--aime_2026","name":"Official MathArena Evaluation","isExternal":true},"filename":".eval_results/MathArena--aime_2026.yaml","verified":false,"pullRequest":35,"label":"MathArena Aime 2026"}],"private":false,"repoType":"model","gated":false,"tags":["transformers","safetensors","qwen3_5","image-text-to-text","conversational","base_model:Qwen/Qwen3.5-9B-Base","base_model:finetune:Qwen/Qwen3.5-9B-Base","license:apache-2.0","eval-results","endpoints_compatible","deploy:sagemaker","deploy:azure","region:us"],"tag_objs":[{"id":"image-text-to-text","label":"Image-Text-to-Text","type":"pipeline_tag","subType":"multimodal"},{"id":"transformers","label":"Transformers","type":"library"},{"id":"safetensors","label":"Safetensors","type":"library"},{"id":"qwen3_5","label":"qwen3_5","type":"other","clickable":true},{"id":"conversational","label":"conversational","type":"other","clickable":true},{"id":"base_model:Qwen/Qwen3.5-9B-Base","label":"base_model:Qwen/Qwen3.5-9B-Base","type":"other","clickable":true},{"id":"base_model:finetune:Qwen/Qwen3.5-9B-Base","label":"base_model:finetune:Qwen/Qwen3.5-9B-Base","type":"other","clickable":true},{"id":"eval-results","label":"Eval Results","type":"other","clickable":true},{"id":"endpoints_compatible","label":"Inference Endpoints","type":"other","clickable":true},{"id":"license:apache-2.0","label":"apache-2.0","type":"license"},{"id":"deploy:sagemaker","label":"sagemaker","type":"deploy"},{"id":"deploy:azure","label":"azure","type":"deploy"},{"type":"region","label":"🇺🇸 Region: US","id":"region:us"}],"transformersInfo":{"auto_model":"AutoModelForMultimodalLM","pipeline_tag":"image-text-to-text","processor":"AutoProcessor"},"widgetData":[{"text":"Hi, what can you help me with?"},{"text":"What is 84 * 3 / 2?"},{"text":"Tell me an interesting fact about the universe!"},{"text":"Explain quantum computing in simple terms."}],"safetensors":{"parameters":{"BF16":9653100528,"F32":3840},"total":9653104368,"sharded":true,"totalFileSize":19306390537},"hasBlockedOids":false,"region":"us","isQuantized":false,"licenseFilePath":"LICENSE"},"discussionsStats":{"closed":7,"open":59,"total":66},"query":{},"inferenceContextData":{"billableEntities":[],"entityName2Providers":{},"defaultProviders":[{"isOriginalProvider":false,"name":"together","enabled":true,"position":5,"isReleased":true,"accuratePricing":true},{"isOriginalProvider":false,"name":"featherless-ai","enabled":true,"position":7,"isReleased":true,"accuratePricing":true},{"isOriginalProvider":false,"name":"ovhcloud","enabled":true,"position":14,"isReleased":true,"accuratePricing":true},{"isOriginalProvider":false,"name":"deepinfra","enabled":true,"position":16,"isReleased":true,"accuratePricing":true}]},"hasQuantizations":true,"copyToBucketNamespaces":[]}">
# [
](/Qwen)
[Qwen](/Qwen) /

[Qwen3.5-9B](/Qwen/Qwen3.5-9B)
like 1.86k

Follow
Qwen 101k

[
Image-Text-to-Text
](/models?pipeline_tag=image-text-to-text)[ Transformers
](/models?library=transformers)[ Safetensors
](/models?library=safetensors)[ qwen3_5
](/models?other=qwen3_5)[ conversational
](/models?other=conversational)[ Eval Results
](/models?other=eval-results) License: apache-2.0

[ Model card ](/Qwen/Qwen3.5-9B)[ Files Files and versions xet
](/Qwen/Qwen3.5-9B/tree/main)[ Community 66
](/Qwen/Qwen3.5-9B/discussions)

Deploy

Copy to bucket new
Use this model
### Instructions to use Qwen/Qwen3.5-9B with libraries, inference providers, notebooks, and local apps. Follow these links to get started.

- Libraries
- [ Transformers](/Qwen/Qwen3.5-9B?library=transformers) How to use Qwen/Qwen3.5-9B with Transformers:
# Use a pipeline as a high-level helper
from transformers import pipeline

pipe = pipeline("image-text-to-text", model="Qwen/Qwen3.5-9B")
messages = [
{
"role": "user",
"content": [
{"type": "image", "url": "https://huggingface.co/datasets/huggingface/documentation-images/resolve/main/p-blog/candy.JPG"},
{"type": "text", "text": "What animal is on the candy?"}
]
},
]
pipe(text=messages) # Load model directly
from transformers import AutoProcessor, AutoModelForMultimodalLM

processor = AutoProcessor.from_pretrained("Qwen/Qwen3.5-9B")
model = AutoModelForMultimodalLM.from_pretrained("Qwen/Qwen3.5-9B", device_map="auto")
messages = [
{
"role": "user",
"content": [
{"type": "image", "url": "https://huggingface.co/datasets/huggingface/documentation-images/resolve/main/p-blog/candy.JPG"},
{"type": "text", "text": "What animal is on the candy?"}
]
},
]
inputs = processor.apply_chat_template(
messages,
add_generation_prompt=True,
tokenize=True,
return_dict=True,
return_tensors="pt",
).to(model.device)

outputs = model.generate(**inputs, max_new_tokens=40)
print(processor.decode(outputs[0][inputs["input_ids"].shape[-1]:]))
- Inference
- Inference Providers
- [ HuggingChat](/chat/models/Qwen/Qwen3.5-9B)
- Notebooks
- [ Google Colab](/Qwen/Qwen3.5-9B/colab)
- [ Kaggle](/Qwen/Qwen3.5-9B/kaggle)
- [ AMD Developer Cloud](/Qwen/Qwen3.5-9B/amd)
- Local Apps [Settings](/settings/local-apps)
- [ vLLM ](/Qwen/Qwen3.5-9B?local-app=vllm) How to use Qwen/Qwen3.5-9B with vLLM:

##### Install from pip and serve model
# Install vLLM from pip:
pip install vllm
# Start the vLLM server:
vllm serve "Qwen/Qwen3.5-9B"
# Call the server using curl (OpenAI-compatible API):
curl -X POST "http://localhost:8000/v1/chat/completions" \
-H "Content-Type: application/json" \
--data '{
"model": "Qwen/Qwen3.5-9B",
"messages": [
{
"role": "user",
"content": [
{
"type": "text",
"text": "Describe this image in one sentence."
},
{
"type": "image_url",
"image_url": {
"url": "https://cdn.britannica.com/61/93061-050-99147DCE/Statue-of-Liberty-Island-New-York-Bay.jpg"
}
}
]
}
]
}'
##### Use Docker
docker model run hf.co/Qwen/Qwen3.5-9B
- [ SGLang ](/Qwen/Qwen3.5-9B?local-app=sglang) How to use Qwen/Qwen3.5-9B with SGLang:

##### Install from pip and serve model
# Install SGLang from pip:
pip install sglang
# Start the SGLang server:
python3 -m sglang.launch_server \
--model-path "Qwen/Qwen3.5-9B" \
--host 0.0.0.0 \
--port 30000
# Call the server using curl (OpenAI-compatible API):
curl -X POST "http://localhost:30000/v1/chat/completions" \
-H "Content-Type: application/json" \
--data '{
"model": "Qwen/Qwen3.5-9B",
"messages": [
{
"role": "user",
"content": [
{
"type": "text",
"text": "Describe this image in one sentence."
},
{
"type": "image_url",
"image_url": {
"url": "https://cdn.britannica.com/61/93061-050-99147DCE/Statue-of-Liberty-Island-New-York-Bay.jpg"
}
}
]
}
]
}'
##### Use Docker images
docker run --gpus all \
--shm-size 32g \
-p 30000:30000 \
-v ~/.cache/huggingface:/root/.cache/huggingface \
--env "HF_TOKEN=<secret>" \
--ipc=host \
lmsysorg/sglang:latest \
python3 -m sglang.launch_server \
--model-path "Qwen/Qwen3.5-9B" \
--host 0.0.0.0 \
--port 30000
# Call the server using curl (OpenAI-compatible API):
curl -X POST "http://localhost:30000/v1/chat/completions" \
-H "Content-Type: application/json" \
--data '{
"model": "Qwen/Qwen3.5-9B",
"messages": [
{
"role": "user",
"content": [
{
"type": "text",
"text": "Describe this image in one sentence."
},
{
"type": "image_url",
"image_url": {
"url": "https://cdn.britannica.com/61/93061-050-99147DCE/Statue-of-Liberty-Island-New-York-Bay.jpg"
}
}
]
}
]
}'
- [ Docker Model Runner ](/Qwen/Qwen3.5-9B?local-app=docker-model-runner) How to use Qwen/Qwen3.5-9B with Docker Model Runner:
docker model run hf.co/Qwen/Qwen3.5-9B
- [Browse
Quantizations](/models?other=base_model:quantized:Qwen/Qwen3.5-9B) to use this model in llama.cpp, Ollama, LM Studio, or any compatible app.

- [Qwen3.5-9B](#qwen35-9b) [Qwen3.5 Highlights](#qwen35-highlights)

- [Model Overview](#model-overview)

- [Benchmark Results](#benchmark-results) [Language](#language)
- [Vision Language](#vision-language)

- [Quickstart](#quickstart) [Serving Qwen3.5](#serving-qwen35)
- [Using Qwen3.5 via the Chat Completions API](#using-qwen35-via-the-chat-completions-api)

- [Agentic Usage](#agentic-usage) [Qwen-Agent](#qwen-agent)
- [Qwen Code](#qwen-code)

- [Processing Ultra-Long Texts](#processing-ultra-long-texts)

- [Best Practices](#best-practices) [Citation](#citation)

#
[

](#qwen35-9b)

Qwen3.5-9B

[](https://chat.qwen.ai)

This repository contains model weights and configuration files for the post-trained model in the Hugging Face Transformers format.

These artifacts are compatible with Hugging Face Transformers, vLLM, SGLang, KTransformers, etc.

Over recent months, we have intensified our focus on developing foundation models that deliver exceptional utility and performance. Qwen3.5 represents a significant leap forward, integrating breakthroughs in multimodal learning, architectural efficiency, reinforcement learning scale, and global accessibility to empower developers and enterprises with unprecedented capability and efficiency.

##
[

](#qwen35-highlights)

Qwen3.5 Highlights

Qwen3.5 features the following enhancement:

- Unified Vision-Language Foundation: Early fusion training on multimodal tokens achieves cross-generational parity with Qwen3 and outperforms Qwen3-VL models across reasoning, coding, agents, and visual understanding benchmarks.

- Efficient Hybrid Architecture: Gated Delta Networks combined with sparse Mixture-of-Experts deliver high-throughput inference with minimal latency and cost overhead.

- Scalable RL Generalization: Reinforcement learning scaled across million-agent environments with progressively complex task distributions for robust real-world adaptability.

- Global Linguistic Coverage: Expanded support to 201 languages and dialects, enabling inclusive, worldwide deployment with nuanced cultural and regional understanding.

- Next-Generation Training Infrastructure: Near-100% multimodal training efficiency compared to text-only training and asynchronous RL frameworks supporting massive-scale agent scaffolds and environment orchestration.

[](https://qianwen-res.oss-accelerate-overseas.aliyuncs.com/Qwen3.5/Figures/qwen3.5_small_size_score.png)

For more details, please refer to our blog post [Qwen3.5](https://qwen.ai/blog?id=qwen3.5).

##
[

](#model-overview)

Model Overview

- Type: Causal Language Model with Vision Encoder

- Training Stage: Pre-training & Post-training

- Language Model
Number of Parameters: 9B

- Hidden Dimension: 4096

- Token Embedding: 248320 (Padded)

- Number of Layers: 32

- Hidden Layout: 8 × (3 × (Gated DeltaNet → FFN) → 1 × (Gated Attention → FFN))

- Gated DeltaNet:
Number of Linear Attention Heads: 32 for V and 16 for QK

- Head Dimension: 128

- Gated Attention:
Number of Attention Heads: 16 for Q and 4 for KV

- Head Dimension: 256

- Rotary Position Embedding Dimension: 64

- Feed Forward Network:
Intermediate Dimension: 12288

- LM Output: 248320 (Padded)

- MTP: trained with multi-steps

- Context Length: 262,144 natively and extensible up to 1,010,000 tokens.

##
[

](#benchmark-results)

Benchmark Results

###
[

](#language)

Language

GPT-OSS-120BGPT-OSS-20BQwen3-Next-80B-A3B-ThinkingQwen3-30BA3B-Thinking-2507Qwen3.5-9BQwen3.5-4B

Knowledge & STEM

MMLU-Pro
80.8
74.8
82.7
80.9
82.5
79.1

MMLU-Redux
91.0
87.8
92.5
91.4
91.1
88.8

C-Eval
76.2
71.4
89.7
87.4
88.2
85.1

SuperGPQA
54.6
48.5
60.8
56.8
58.2
52.9

GPQA Diamond
80.1
71.5
77.2
73.4
81.7
76.2

Instruction Following

IFEval
88.9
88.2
88.9
88.9
91.5
89.8

IFBench
69.0
65.1
61.5
51.5
64.5
59.2

MultiChallenge
45.3
40.1
51.3
46.5
54.5
49.0

Long Context

AA-LCR
50.7
30.7
51.7
49.0
63.0
57.0

LongBench v2
48.2
45.6
48.0
44.8
55.2
50.0

Reasoning & Coding

HMMT Feb 25
90.0
76.7
73.7
63.1
83.2
74.0

HMMT Nov 25
90.0
81.8
81.2
73.8
82.9
76.8

LiveCodeBench v6
82.7
74.6
68.7
66.0
65.6
55.8

OJBench
41.5
36.3
29.7
25.1
29.2
24.1

General Agent

BFCL-V4
--
--
49.7
42.4
66.1
50.3

TAU2-Bench
--
--
57.4
41.9
79.1
79.9

VITA-Bench
--
--
29.5
14.1
29.8
22.0

DeepPlanning
--
--
0.4
4.9
18.0
17.6

Multilingualism

MMMLU
78.2
69.7
81.3
78.4
81.2
76.1

MMLU-ProX
74.5
67.3
73.6
69.1
76.3
71.5

NOVA-63
51.1
48.7
53.3
52.5
55.9
54.3

INCLUDE
74.0
65.3
78.3
74.4
75.6
71.0

Global PIQA
84.1
79.8
83.5
80.2
83.2
78.9

PolyMATH
54.0
30.9
62.4
52.6
57.3
51.1

WMT24++
74.4
67.8
57.4
69.3
72.6
66.6

MAXIFE
83.7
80.1
79.9
77.4
83.4
78.0

* TAU2-Bench: we follow the official setup except for the airline domain, where all models are evaluated by applying the fixes proposed in the Claude Opus 4.5 system card.

* MMLU-ProX: we report the averaged accuracy on 29 languages.

* WMT24++: a harder subset of WMT24 after difficulty labeling and rebalancing; we report the averaged scores on 55 languages using XCOMET-XXL.

* MAXIFE: we report the accuracy on English + multilingual original prompts (totally 23 settings).

* Empty cells (--) indicate scores not yet available or not applicable.

###
[

](#vision-language)

Vision Language

GPT-5-Nano-2025-08-07Gemini-2.5-Flash-LiteQwen3-VL-30B-A3BQwen3.5-9BQwen3.5-4B

STEM and Puzzle

MMMU
75.8
73.4
76.0
78.4
77.6

MMMU-Pro
57.2
59.7
63.0
70.1
66.3

MathVision
62.2
52.1
65.7
78.9
74.6

Mathvista(mini)
71.5
72.8
81.9
85.7
85.1

We-Math
62.5
32.1
70.0
75.2
75.4

DynaMath
78.0
69.9
80.1
83.6
83.3

ZEROBench
1.0
1.0
0.0
3.0
3.0

ZEROBench_sub
22.2
19.2
23.7
31.1
26.3

VlmsAreBlind
66.7
68.4
72.5
93.7
92.6

BabyVision
14.4
17.5
18.6
28.6/25.8
16.0/19.1

General VQA

RealWorldQA
71.8
72.2
77.4
80.3
79.5

MMStar
68.6
69.1
75.5
79.7
78.3

MMBenchEN-DEV-v1.1
80.3
82.7
88.9
90.1
89.4

SimpleVQA
46.0
54.1
54.3
51.2
43.4

HallusionBench
58.4
64.5
66.0
69.3
65.0

Text Recognition and Document Understanding

OmniDocBench1.5
55.9
79.4
86.8
87.7
86.2

CharXiv(RQ)
50.1
56.1
56.6
73.0
70.8

MMLongBench-Doc
31.8
46.5
47.4
57.7
54.2

CC-OCR
58.9
72.9
77.8
79.3
76.7

AI2D_TEST
81.9
85.7
86.9
90.2
89.6

OCRBench
75.3
82.5
83.9
89.2
85.0

Spatial Intelligence

ERQA
45.8
44.3
45.3
55.5
54.0

CountBench
80.0
79.2
90.0
97.2
96.3

RefCOCO(avg)
--
--
89.3
89.7
88.1

EmbSpatialBench
74.2
66.1
80.6
83.0
81.3

RefSpatialBench
12.6
11.2
54.2
58.5
54.6

LingoQA
57.0
17.8
62.0
80.4
74.4

Hypersim
--
--
11.4
13.5
12.5

Nuscene
--
--
10.3
11.8
9.9

Video Understanding

VideoMME(w sub.)
71.7
74.6
79.9
84.5
83.5

VideoMME(w/o sub.)
66.2
72.7
73.3
78.4
76.9

VideoMMMU
63.0
69.2
75.0
78.9
74.1

MLVU
69.2
78.5
78.9
84.4
82.8

MVBench
--
--
72.0
74.4
71.2

LVBench
--
60.9
59.2
70.0
66.4

MMVU
63.1
65.3
66.1
67.8
64.9

Visual Agent

ScreenSpot Pro
--
--
60.5
65.2
60.3

OSWorld-Verified
--
--
30.6
41.8
35.6

AndroidWorld
--
--
55.0
57.8
58.6

Tool Calling

TIR-Bench
18.5
21.5
22.5
45.6/31.9
38.9/29.9

V*
68.1
69.6
83.2
90.1/88.5
84.3/86.4

Medical VQA

SLAKE
57.0
65.0
68.8
79.0
76.1

PMC-VQA
37.8
48.8
51.5
57.9
55.5

MedXpertQA-MM
26.7
35.3
35.5
49.9
42.9

* MathVision: our model’s score is evaluated using a fixed prompt, e.g., “Please reason step by step, and put your final answer within \boxed{}.” For other models, we report the higher score between runs with and without the \boxed{} formatting.

* BabyVision: scores reported as "with CI / without CI".

* TIR-Bench and V*: scores reported as "with CI / without CI".

* Empty cells (--) indicate scores not yet available or not applicable.

##
[

](#quickstart)

Quickstart

Qwen3.5 models operate in thinking mode by default, generating thinking content signified by <think>\n...</think>\n\n before producing the final responses.
To disable thinking content and obtain direct response, refer to the examples [here](#instruct-or-non-thinking-mode).

For streamlined integration, we recommend using Qwen3.5 via APIs. Below is a guide to use Qwen3.5 via OpenAI-compatible API.

###
[

](#serving-qwen35)

Serving Qwen3.5

Qwen3.5 can be served via APIs with popular inference frameworks.
In the following, we show example commands to launch OpenAI-Compatible API servers for Qwen3.5 models.

Inference efficiency and throughput vary significantly across frameworks.
We recommend using the latest framework versions to ensure optimal performance and compatibility.
For production workloads or high-throughput scenarios, dedicated serving engines such as SGLang, KTransformers or vLLM are strongly recommended.

The model has a default context length of 262,144 tokens.
If you encounter out-of-memory (OOM) errors, consider reducing the context window.
However, because Qwen3.5 leverages extended context for complex tasks, we advise maintaining a context length of at least 128K tokens to preserve thinking capabilities.

####
[

](#sglang)

SGLang

[SGLang](https://github.com/sgl-project/sglang) is a fast serving framework for large language models and vision language models.
SGLang from the main branch of the open-source repository is required for Qwen3.5, which can be installed using the following command in a fresh environment:

uv pip install 'git+https://github.com/sgl-project/sglang.git#subdirectory=python&egg=sglang[all]'

See [its documentation](https://docs.sglang.ai/get_started/install.html) for more details.

The following will create API endpoints at http://localhost:8000/v1:

- Standard Version: The following command can be used to create an API endpoint with maximum context length 262,144 tokens using tensor parallel on 8 GPUs.

python -m sglang.launch_server --model-path Qwen/Qwen3.5-9B --port 8000 --tp-size 1 --mem-fraction-static 0.8 --context-length 262144 --reasoning-parser qwen3

- Tool Use: To support tool use, you can use the following command.

python -m sglang.launch_server --model-path Qwen/Qwen3.5-9B --port 8000 --tp-size 1 --mem-fraction-static 0.8 --context-length 262144 --reasoning-parser qwen3 --tool-call-parser qwen3_coder

- Multi-Token Prediction (MTP): The following command is recommended for MTP:

python -m sglang.launch_server --model-path Qwen/Qwen3.5-9B --port 8000 --tp-size 1 --mem-fraction-static 0.8 --context-length 262144 --reasoning-parser qwen3 --speculative-algo NEXTN --speculative-num-steps 3 --speculative-eagle-topk 1 --speculative-num-draft-tokens 4

####
[

](#vllm)

vLLM

[vLLM](https://github.com/vllm-project/vllm) is a high-throughput and memory-efficient inference and serving engine for LLMs.
vLLM from the main branch of the open-source repository is required for Qwen3.5, which can be installed using the following command in a fresh environment:

uv pip install vllm --torch-backend=auto --extra-index-url https://wheels.vllm.ai/nightly

See [its documentation](https://docs.vllm.ai/en/stable/getting_started/installation/index.html) for more details.

For detailed Qwen3.5 usage guide, see the [vLLM Qwen3.5 recipe](https://docs.vllm.ai/projects/recipes/en/latest/Qwen/Qwen3.5.html).

The following will create API endpoints at http://localhost:8000/v1:

- Standard Version: The following command can be used to create an API endpoint with maximum context length 262,144 tokens using tensor parallel on 8 GPUs.

vllm serve Qwen/Qwen3.5-9B --port 8000 --tensor-parallel-size 1 --max-model-len 262144 --reasoning-parser qwen3

- Tool Call: To support tool use, you can use the following command.

vllm serve Qwen/Qwen3.5-9B --port 8000 --tensor-parallel-size 1 --max-model-len 262144 --reasoning-parser qwen3 --enable-auto-tool-choice --tool-call-parser qwen3_coder

- Multi-Token Prediction (MTP): The following command is recommended for MTP:

vllm serve Qwen/Qwen3.5-9B --port 8000 --tensor-parallel-size 1 --max-model-len 262144 --reasoning-parser qwen3 --speculative-config '{"method":"qwen3_next_mtp","num_speculative_tokens":2}'

- Text-Only: The following command skips the vision encoder and multimodal profiling to free up memory for additional KV cache:

vllm serve Qwen/Qwen3.5-9B --port 8000 --tensor-parallel-size 1 --max-model-len 262144 --reasoning-parser qwen3 --language-model-only

####
[

](#ktransformers)

KTransformers

[KTransformers](https://github.com/kvcache-ai/ktransformers) is a flexible framework for experiencing cutting-edge LLM inference optimizations with CPU-GPU heterogeneous computing.
For running Qwen3.5 with KTransformers, see the [KTransformers Deployment Guide](https://github.com/kvcache-ai/ktransformers/blob/main/doc/en/Qwen3.5.md).

####
[

](#hugging-face-transformers)

Hugging Face Transformers

Hugging Face Transformers contains a lightweight server which can be used for quick testing and moderate load deployment.
The latest transformers is required for Qwen3.5:

pip install "transformers[serving] @ git+https://github.com/huggingface/transformers.git@main"

See [its documentation](https://huggingface.co/docs/transformers/main/serving) for more details. Please also make sure torchvision and pillow are installed.

Then, run transformers serve to launch a server with API endpoints at http://localhost:8000/v1; it will place the model on accelerators if available:

transformers serve --force-model Qwen/Qwen3.5-9B --port 8000 --continuous-batching

###
[

](#using-qwen35-via-the-chat-completions-api)

Using Qwen3.5 via the Chat Completions API

The chat completions API is accessible via standard HTTP requests or OpenAI SDKs.
Here, we show examples using the OpenAI Python SDK.

Before starting, make sure it is installed and the API key and the API base URL is configured, e.g.:

pip install -U openai

# Set the following accordingly
export OPENAI_BASE_URL="http://localhost:8000/v1"
export OPENAI_API_KEY="EMPTY"

We recommend using the following set of sampling parameters for generation

- Thinking mode for general tasks: temperature=1.0, top_p=0.95, top_k=20, min_p=0.0, presence_penalty=1.5, repetition_penalty=1.0

- Thinking mode for precise coding tasks (e.g. WebDev): temperature=0.6, top_p=0.95, top_k=20, min_p=0.0, presence_penalty=0.0, repetition_penalty=1.0

- Instruct (or non-thinking) mode for general tasks: temperature=0.7, top_p=0.8, top_k=20, min_p=0.0, presence_penalty=1.5, repetition_penalty=1.0

- Instruct (or non-thinking) mode for reasoning tasks: temperature=1.0, top_p=0.95, top_k=20, min_p=0.0, presence_penalty=1.5, repetition_penalty=1.0

Please note that the support for sampling parameters varies according to inference frameworks.

####
[

](#text-only-input)

Text-Only Input

from openai import OpenAI
# Configured by environment variables
client = OpenAI()

messages = [
{"role": "user", "content": "Type \"I love Qwen3.5\" backwards"},
]

chat_response = client.chat.completions.create(
model="Qwen/Qwen3.5-9B",
messages=messages,
max_tokens=81920,
temperature=1.0,
top_p=0.95,
presence_penalty=1.5,
extra_body={
"top_k": 20,
},
)
print("Chat response:", chat_response)

####
[

](#image-input)

Image Input

from openai import OpenAI
# Configured by environment variables
client = OpenAI()

messages = [
{
"role": "user",
"content": [
{
"type": "image_url",
"image_url": {
"url": "https://qianwen-res.oss-accelerate.aliyuncs.com/Qwen3.5/demo/CI_Demo/mathv-1327.jpg"
}
},
{
"type": "text",
"text": "The centres of the four illustrated circles are in the corners of the square. The two big circles touch each other and also the two little circles. With which factor do you have to multiply the radii of the little circles to obtain the radius of the big circles?\nChoices:\n(A) $\\frac{2}{9}$\n(B) $\\sqrt{5}$\n(C) $0.8 \\cdot \\pi$\n(D) 2.5\n(E) $1+\\sqrt{2}$"
}
]
}
]

chat_response = client.chat.completions.create(
model="Qwen/Qwen3.5-9B",
messages=messages,
max_tokens=81920,
temperature=1.0,
top_p=0.95,
presence_penalty=1.5,
extra_body={
"top_k": 20,
},
)
print("Chat response:", chat_response)

####
[

](#video-input)

Video Input

from openai import OpenAI
# Configured by environment variables
client = OpenAI()

messages = [
{
"role": "user",
"content": [
{
"type": "video_url",
"video_url": {
"url": "https://qianwen-res.oss-accelerate.aliyuncs.com/Qwen3.5/demo/video/N1cdUjctpG8.mp4"
}
},
{
"type": "text",
"text": "Summarize the video content."
}
]
}
]

# When vLLM is launched with `--media-io-kwargs '{"video": {"num_frames": -1}}'`,
# video frame sampling can be configured via `extra_body` (e.g., by setting `fps`).
# This feature is currently supported only in vLLM.
#
# By default, `fps=2` and `do_sample_frames=True`.
# With `do_sample_frames=True`, you can customize the `fps` value to set your desired video sampling rate.
chat_response = client.chat.completions.create(
model="Qwen/Qwen3.5-9B",
messages=messages,
max_tokens=81920,
temperature=1.0,
top_p=0.95,
presence_penalty=1.5,
extra_body={
"top_k": 20,
"mm_processor_kwargs": {"fps": 2, "do_sample_frames": True},
},
)

print("Chat response:", chat_response)

####
[

](#instruct-or-non-thinking-mode)

Instruct (or Non-Thinking) Mode

Qwen3.5 does not officially support the soft switch of Qwen3, i.e., /think and /nothink.

Qwen3.5 will think by default before response.
You can obtain direct response from the model without thinking by configuring the API parameters.
For example,

from openai import OpenAI
# Configured by environment variables
client = OpenAI()

messages = [
{
"role": "user",
"content": [
{
"type": "image_url",
"image_url": {
"url": "https://qianwen-res.oss-accelerate.aliyuncs.com/Qwen3.5/demo/RealWorld/RealWorld-04.png"
}
},
{
"type": "text",
"text": "Where is this?"
}
]
}
]

chat_response = client.chat.completions.create(
model="Qwen/Qwen3.5-9B",
messages=messages,
max_tokens=32768,
temperature=0.7,
top_p=0.8,
presence_penalty=1.5,
extra_body={
"top_k": 20,
"chat_template_kwargs": {"enable_thinking": False},
},
)
print("Chat response:", chat_response)

If you are using APIs from Alibaba Cloud Model Studio, in addition to changing model, please use "enable_thinking": False instead of "chat_template_kwargs": {"enable_thinking": False}.

##
[

](#agentic-usage)

Agentic Usage

Qwen3.5 excels in tool calling capabilities.

###
[

](#qwen-agent)

Qwen-Agent

We recommend using [Qwen-Agent](https://github.com/QwenLM/Qwen-Agent) to quickly build Agent applications with Qwen3.5.

To define the available tools, you can use the MCP configuration file, use the integrated tool of Qwen-Agent, or integrate other tools by yourself.

import os
from qwen_agent.agents import Assistant

# Define LLM
# Using Alibaba Cloud Model Studio
llm_cfg = {
# Use the OpenAI-compatible model service provided by DashScope:
'model': 'Qwen3.5-9B',
'model_type': 'qwenvl_oai',
'model_server': 'https://dashscope.aliyuncs.com/compatible-mode/v1',
'api_key': os.getenv('DASHSCOPE_API_KEY'),

'generate_cfg': {
'use_raw_api': True,
# When using Dash Scope OAI API, pass the parameter of whether to enable thinking mode in this way
'extra_body': {
'enable_thinking': True
},
},
}

# Using OpenAI-compatible API endpoint.
# functionality of the deployment frameworks and let Qwen-Agent automate the related operations.
#
# llm_cfg = {
# # Use your own model service compatible with OpenAI API by vLLM/SGLang:
# 'model': 'Qwen/Qwen3.5-9B',
# 'model_type': 'qwenvl_oai',
# 'model_server': 'http://localhost:8000/v1', # api_base
# 'api_key': 'EMPTY',
#
# 'generate_cfg': {
# 'use_raw_api': True,
# # When using vLLM/SGLang OAI API, pass the parameter of whether to enable thinking mode in this way
# 'extra_body': {
# 'chat_template_kwargs': {'enable_thinking': True}
# },
# },
# }

# Define Tools
tools = [
{'mcpServers': { # You can specify the MCP configuration file
"filesystem": {
"command": "npx",
"args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/xxxx/Desktop"]
}
}
}
]

# Define Agent
bot = Assistant(llm=llm_cfg, function_list=tools)

# Streaming generation
messages = [{'role': 'user', 'content': 'Help me organize my desktop.'}]
for responses in bot.run(messages=messages):
pass
print(responses)

# Streaming generation
messages = [{'role': 'user', 'content': 'Develop a dog website and save it on the desktop'}]
for responses in bot.run(messages=messages):
pass
print(responses)

###
[

](#qwen-code)

Qwen Code

[Qwen Code](https://github.com/QwenLM/qwen-code) is an open-source AI agent for the terminal, optimized for Qwen models. It helps you understand large codebases, automate tedious work, and ship faster.

For more information, please refer to [Qwen Code](https://qwenlm.github.io/qwen-code-docs/).

##
[

](#processing-ultra-long-texts)

Processing Ultra-Long Texts

Qwen3.5 natively supports context lengths of up to 262,144 tokens.
For long-horizon tasks where the total length (including both input and output) exceeds this limit, we recommend using RoPE scaling techniques to handle long texts effectively., e.g., YaRN.

YaRN is currently supported by several inference frameworks, e.g., transformers, vllm, ktransformers and sglang.
In general, there are two approaches to enabling YaRN for supported frameworks:

- Modifying the model configuration file:
In the config.json file, change the rope_parameters fields in text_config to:

{
"mrope_interleaved": true,
"mrope_section": [
11,
11,
10
],
"rope_type": "yarn",
"rope_theta": 10000000,
"partial_rotary_factor": 0.25,
"factor": 4.0,
"original_max_position_embeddings": 262144,
}

- Passing command line arguments:

For vllm, you can use

VLLM_ALLOW_LONG_MAX_MODEL_LEN=1 vllm serve ... --hf-overrides '{"text_config": {"rope_parameters": {"mrope_interleaved": true, "mrope_section": [11, 11, 10], "rope_type": "yarn", "rope_theta": 10000000, "partial_rotary_factor": 0.25, "factor": 4.0, "original_max_position_embeddings": 262144}}}' --max-model-len 1010000

For sglang and ktransformers, you can use

SGLANG_ALLOW_OVERWRITE_LONGER_CONTEXT_LEN=1 python -m sglang.launch_server ... --json-model-override-args '{"text_config": {"rope_parameters": {"mrope_interleaved": true, "mrope_section": [11, 11, 10], "rope_type": "yarn", "rope_theta": 10000000, "partial_rotary_factor": 0.25, "factor": 4.0, "original_max_position_embeddings": 262144}}}' --context-length 1010000

All the notable open-source frameworks implement static YaRN, which means the scaling factor remains constant regardless of input length, potentially impacting performance on shorter texts.
We advise modifying the rope_parameters configuration only when processing long contexts is required.
It is also recommended to modify the factor as needed. For example, if the typical context length for your application is 524,288 tokens, it would be better to set factor as 2.0.

##
[

](#best-practices)

Best Practices

To achieve optimal performance, we recommend the following settings:

- Sampling Parameters:

We suggest using the following sets of sampling parameters depending on the mode and task type:
Thinking mode for general tasks:
temperature=1.0, top_p=0.95, top_k=20, min_p=0.0, presence_penalty=1.5, repetition_penalty=1.0

- Thinking mode for precise coding tasks (e.g., WebDev):
temperature=0.6, top_p=0.95, top_k=20, min_p=0.0, presence_penalty=0.0, repetition_penalty=1.0

- Instruct (or non-thinking) mode for general tasks:
temperature=0.7, top_p=0.8, top_k=20, min_p=0.0, presence_penalty=1.5, repetition_penalty=1.0

- Instruct (or non-thinking) mode for reasoning tasks:
temperature=1.0, top_p=1.0, top_k=40, min_p=0.0, presence_penalty=2.0, repetition_penalty=1.0

- For supported frameworks, you can adjust the presence_penalty parameter between 0 and 2 to reduce endless repetitions. However, using a higher value may occasionally result in language mixing and a slight decrease in model performance.

- Adequate Output Length: We recommend using an output length of 32,768 tokens for most queries. For benchmarking on highly complex problems, such as those found in math and programming competitions, we suggest setting the max output length to 81,920 tokens. This provides the model with sufficient space to generate detailed and comprehensive responses, thereby enhancing its overall performance.

- Standardize Output Format: We recommend using prompts to standardize model outputs when benchmarking.

Math Problems: Include "Please reason step by step, and put your final answer within \boxed{}." in the prompt.

- Multiple-Choice Questions: Add the following JSON structure to the prompt to standardize responses: "Please show your choice in the answer field with only the choice letter, e.g., "answer": "C"."

- No Thinking Content in History: In multi-turn conversations, the historical model output should only include the final output part and does not need to include the thinking content. It is implemented in the provided chat template in Jinja2. However, for frameworks that do not directly use the Jinja2 chat template, it is up to the developers to ensure that the best practice is followed.

- Long Video Understanding: To optimize inference efficiency for plain text and images, the size parameter in the released video_preprocessor_config.json is conservatively configured. It is recommended to set the longest_edge parameter in the video_preprocessor_config file to 469,762,048 (corresponding to 224k video tokens) to enable higher frame-rate sampling for hour-scale videos and thereby achieve superior performance. For example,

{"longest_edge": 469762048, "shortest_edge": 4096}

Alternatively, override the default values via engine startup parameters. For implementation details, refer to: [vLLM](https://github.com/vllm-project/vllm/pull/34330) / [SGLang](https://github.com/sgl-project/sglang/pull/18467).

###
[

](#citation)

Citation

If you find our work helpful, feel free to give us a cite.

@misc{qwen3.5,
title = {{Qwen3.5}: Towards Native Multimodal Agents},
author = {{Qwen Team}},
month = {February},
year = {2026},
url = {https://qwen.ai/blog?id=qwen3.5}
}

Downloads last month 13,442,398

<|image_pad|><|vision_end|>' }}\n {%- elif 'video' in item or item.type == 'video' %}\n {%- if is_system_content %}\n {{- raise_exception('System message cannot contain videos.') }}\n {%- endif %}\n {%- if do_vision_count %}\n {%- set video_count.value = video_count.value + 1 %}\n {%- endif %}\n {%- if add_vision_id %}\n {{- 'Video ' ~ video_count.value ~ ': ' }}\n {%- endif %}\n {{- '<|vision_start|><|video_pad|><|vision_end|>' }}\n {%- elif 'text' in item %}\n {{- item.text }}\n {%- else %}\n {{- raise_exception('Unexpected item type in content.') }}\n {%- endif %}\n {%- endfor %}\n {%- elif content is none or content is undefined %}\n {{- '' }}\n {%- else %}\n {{- raise_exception('Unexpected content type.') }}\n {%- endif %}\n{%- endmacro %}\n{%- if not messages %}\n {{- raise_exception('No messages provided.') }}\n{%- endif %}\n{%- if tools and tools is iterable and tools is not mapping %}\n {{- '<|im_start|>system\\n' }}\n {{- \"# Tools\\n\\nYou have access to the following functions:\\n\\n<tools>\" }}\n {%- for tool in tools %}\n {{- \"\\n\" }}\n {{- tool | tojson }}\n {%- endfor %}\n {{- \"\\n</tools>\" }}\n {{- '\\n\\nIf you choose to call a function ONLY reply in the following format with NO suffix:\\n\\n<tool_call>\\n<function=example_function_name>\\n<parameter=example_parameter_1>\\nvalue_1\\n</parameter>\\n<parameter=example_parameter_2>\\nThis is the value for the second parameter\\nthat can span\\nmultiple lines\\n</parameter>\\n</function>\\n</tool_call>\\n\\n<IMPORTANT>\\nReminder:\\n- Function calls MUST follow the specified format: an inner <function=...></function> block must be nested within <tool_call></tool_call> XML tags\\n- Required parameters MUST be specified\\n- You may provide optional reasoning for your function call in natural language BEFORE the function call, but NOT after\\n- If there is no function call available, answer the question like normal with your current knowledge and do not tell the user about function calls\\n</IMPORTANT>' }}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {%- if content %}\n {{- '\\n\\n' + content }}\n {%- endif %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n{%- else %}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {{- '<|im_start|>system\\n' + content + '<|im_end|>\\n' }}\n {%- endif %}\n{%- endif %}\n{%- set ns = namespace(multi_step_tool=true, last_query_index=messages|length - 1) %}\n{%- for message in messages[::-1] %}\n {%- set index = (messages|length - 1) - loop.index0 %}\n {%- if ns.multi_step_tool and message.role == \"user\" %}\n {%- set content = render_content(message.content, false)|trim %}\n {%- if not(content.startswith('<tool_response>') and content.endswith('</tool_response>')) %}\n {%- set ns.multi_step_tool = false %}\n {%- set ns.last_query_index = index %}\n {%- endif %}\n {%- endif %}\n{%- endfor %}\n{%- if ns.multi_step_tool %}\n {{- raise_exception('No user query found in messages.') }}\n{%- endif %}\n{%- for message in messages %}\n {%- set content = render_content(message.content, true)|trim %}\n {%- if message.role == \"system\" %}\n {%- if not loop.first %}\n {{- raise_exception('System message must be at the beginning.') }}\n {%- endif %}\n {%- elif message.role == \"user\" %}\n {{- '<|im_start|>' + message.role + '\\n' + content + '<|im_end|>' + '\\n' }}\n {%- elif message.role == \"assistant\" %}\n {%- set reasoning_content = '' %}\n {%- if message.reasoning_content is string %}\n {%- set reasoning_content = message.reasoning_content %}\n {%- else %}\n {%- if '</think>' in content %}\n {%- set reasoning_content = content.split('</think>')[0].rstrip('\\n').split('<think>')[-1].lstrip('\\n') %}\n {%- set content = content.split('</think>')[-1].lstrip('\\n') %}\n {%- endif %}\n {%- endif %}\n {%- set reasoning_content = reasoning_content|trim %}\n {%- if loop.index0 > ns.last_query_index %}\n {{- '<|im_start|>' + message.role + '\\n<think>\\n' + reasoning_content + '\\n</think>\\n\\n' + content }}\n {%- else %}\n {{- '<|im_start|>' + message.role + '\\n' + content }}\n {%- endif %}\n {%- if message.tool_calls and message.tool_calls is iterable and message.tool_calls is not mapping %}\n {%- for tool_call in message.tool_calls %}\n {%- if tool_call.function is defined %}\n {%- set tool_call = tool_call.function %}\n {%- endif %}\n {%- if loop.first %}\n {%- if content|trim %}\n {{- '\\n\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- else %}\n {{- '<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- else %}\n {{- '\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- if tool_call.arguments is defined %}\n {%- for args_name, args_value in tool_call.arguments|items %}\n {{- '<parameter=' + args_name + '>\\n' }}\n {%- set args_value = args_value | tojson | safe if args_value is mapping or (args_value is sequence and args_value is not string) else args_value | string %}\n {{- args_value }}\n {{- '\\n</parameter>\\n' }}\n {%- endfor %}\n {%- endif %}\n {{- '</function>\\n</tool_call>' }}\n {%- endfor %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n {%- elif message.role == \"tool\" %}\n {%- if loop.previtem and loop.previtem.role != \"tool\" %}\n {{- '<|im_start|>user' }}\n {%- endif %}\n {{- '\\n<tool_response>\\n' }}\n {{- content }}\n {{- '\\n</tool_response>' }}\n {%- if not loop.last and loop.nextitem.role != \"tool\" %}\n {{- '<|im_end|>\\n' }}\n {%- elif loop.last %}\n {{- '<|im_end|>\\n' }}\n {%- endif %}\n {%- else %}\n {{- raise_exception('Unexpected message role.') }}\n {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n {{- '<|im_start|>assistant\\n' }}\n {%- if enable_thinking is defined and enable_thinking is false %}\n {{- '<think>\\n\\n</think>\\n\\n' }}\n {%- else %}\n {{- '<think>\\n' }}\n {%- endif %}\n{%- endif %}","eos_token":"<|im_end|>","pad_token":"<|endoftext|>","unk_token":null},"chat_template_jinja":"{%- set image_count = namespace(value=0) %}\n{%- set video_count = namespace(value=0) %}\n{%- macro render_content(content, do_vision_count, is_system_content=false) %}\n {%- if content is string %}\n {{- content }}\n {%- elif content is iterable and content is not mapping %}\n {%- for item in content %}\n {%- if 'image' in item or 'image_url' in item or item.type == 'image' %}\n {%- if is_system_content %}\n {{- raise_exception('System message cannot contain images.') }}\n {%- endif %}\n {%- if do_vision_count %}\n {%- set image_count.value = image_count.value + 1 %}\n {%- endif %}\n {%- if add_vision_id %}\n {{- 'Picture ' ~ image_count.value ~ ': ' }}\n {%- endif %}\n {{- '<|vision_start|><|image_pad|><|vision_end|>' }}\n {%- elif 'video' in item or item.type == 'video' %}\n {%- if is_system_content %}\n {{- raise_exception('System message cannot contain videos.') }}\n {%- endif %}\n {%- if do_vision_count %}\n {%- set video_count.value = video_count.value + 1 %}\n {%- endif %}\n {%- if add_vision_id %}\n {{- 'Video ' ~ video_count.value ~ ': ' }}\n {%- endif %}\n {{- '<|vision_start|><|video_pad|><|vision_end|>' }}\n {%- elif 'text' in item %}\n {{- item.text }}\n {%- else %}\n {{- raise_exception('Unexpected item type in content.') }}\n {%- endif %}\n {%- endfor %}\n {%- elif content is none or content is undefined %}\n {{- '' }}\n {%- else %}\n {{- raise_exception('Unexpected content type.') }}\n {%- endif %}\n{%- endmacro %}\n{%- if not messages %}\n {{- raise_exception('No messages provided.') }}\n{%- endif %}\n{%- if tools and tools is iterable and tools is not mapping %}\n {{- '<|im_start|>system\\n' }}\n {{- \"# Tools\\n\\nYou have access to the following functions:\\n\\n<tools>\" }}\n {%- for tool in tools %}\n {{- \"\\n\" }}\n {{- tool | tojson }}\n {%- endfor %}\n {{- \"\\n</tools>\" }}\n {{- '\\n\\nIf you choose to call a function ONLY reply in the following format with NO suffix:\\n\\n<tool_call>\\n<function=example_function_name>\\n<parameter=example_parameter_1>\\nvalue_1\\n</parameter>\\n<parameter=example_parameter_2>\\nThis is the value for the second parameter\\nthat can span\\nmultiple lines\\n</parameter>\\n</function>\\n</tool_call>\\n\\n<IMPORTANT>\\nReminder:\\n- Function calls MUST follow the specified format: an inner <function=...></function> block must be nested within <tool_call></tool_call> XML tags\\n- Required parameters MUST be specified\\n- You may provide optional reasoning for your function call in natural language BEFORE the function call, but NOT after\\n- If there is no function call available, answer the question like normal with your current knowledge and do not tell the user about function calls\\n</IMPORTANT>' }}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {%- if content %}\n {{- '\\n\\n' + content }}\n {%- endif %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n{%- else %}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {{- '<|im_start|>system\\n' + content + '<|im_end|>\\n' }}\n {%- endif %}\n{%- endif %}\n{%- set ns = namespace(multi_step_tool=true, last_query_index=messages|length - 1) %}\n{%- for message in messages[::-1] %}\n {%- set index = (messages|length - 1) - loop.index0 %}\n {%- if ns.multi_step_tool and message.role == \"user\" %}\n {%- set content = render_content(message.content, false)|trim %}\n {%- if not(content.startswith('<tool_response>') and content.endswith('</tool_response>')) %}\n {%- set ns.multi_step_tool = false %}\n {%- set ns.last_query_index = index %}\n {%- endif %}\n {%- endif %}\n{%- endfor %}\n{%- if ns.multi_step_tool %}\n {{- raise_exception('No user query found in messages.') }}\n{%- endif %}\n{%- for message in messages %}\n {%- set content = render_content(message.content, true)|trim %}\n {%- if message.role == \"system\" %}\n {%- if not loop.first %}\n {{- raise_exception('System message must be at the beginning.') }}\n {%- endif %}\n {%- elif message.role == \"user\" %}\n {{- '<|im_start|>' + message.role + '\\n' + content + '<|im_end|>' + '\\n' }}\n {%- elif message.role == \"assistant\" %}\n {%- set reasoning_content = '' %}\n {%- if message.reasoning_content is string %}\n {%- set reasoning_content = message.reasoning_content %}\n {%- else %}\n {%- if '</think>' in content %}\n {%- set reasoning_content = content.split('</think>')[0].rstrip('\\n').split('<think>')[-1].lstrip('\\n') %}\n {%- set content = content.split('</think>')[-1].lstrip('\\n') %}\n {%- endif %}\n {%- endif %}\n {%- set reasoning_content = reasoning_content|trim %}\n {%- if loop.index0 > ns.last_query_index %}\n {{- '<|im_start|>' + message.role + '\\n<think>\\n' + reasoning_content + '\\n</think>\\n\\n' + content }}\n {%- else %}\n {{- '<|im_start|>' + message.role + '\\n' + content }}\n {%- endif %}\n {%- if message.tool_calls and message.tool_calls is iterable and message.tool_calls is not mapping %}\n {%- for tool_call in message.tool_calls %}\n {%- if tool_call.function is defined %}\n {%- set tool_call = tool_call.function %}\n {%- endif %}\n {%- if loop.first %}\n {%- if content|trim %}\n {{- '\\n\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- else %}\n {{- '<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- else %}\n {{- '\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- if tool_call.arguments is defined %}\n {%- for args_name, args_value in tool_call.arguments|items %}\n {{- '<parameter=' + args_name + '>\\n' }}\n {%- set args_value = args_value | tojson | safe if args_value is mapping or (args_value is sequence and args_value is not string) else args_value | string %}\n {{- args_value }}\n {{- '\\n</parameter>\\n' }}\n {%- endfor %}\n {%- endif %}\n {{- '</function>\\n</tool_call>' }}\n {%- endfor %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n {%- elif message.role == \"tool\" %}\n {%- if loop.previtem and loop.previtem.role != \"tool\" %}\n {{- '<|im_start|>user' }}\n {%- endif %}\n {{- '\\n<tool_response>\\n' }}\n {{- content }}\n {{- '\\n</tool_response>' }}\n {%- if not loop.last and loop.nextitem.role != \"tool\" %}\n {{- '<|im_end|>\\n' }}\n {%- elif loop.last %}\n {{- '<|im_end|>\\n' }}\n {%- endif %}\n {%- else %}\n {{- raise_exception('Unexpected message role.') }}\n {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n {{- '<|im_start|>assistant\\n' }}\n {%- if enable_thinking is defined and enable_thinking is false %}\n {{- '<think>\\n\\n</think>\\n\\n' }}\n {%- else %}\n {{- '<think>\\n' }}\n {%- endif %}\n{%- endif %}"},"createdAt":"2026-02-27T12:58:26.000Z","discussionsDisabled":false,"discussionsSorting":"recently-created","downloads":13442398,"downloadsAllTime":55389227,"id":"Qwen/Qwen3.5-9B","isLikedByUser":false,"availableInferenceProviders":[{"provider":"together","modelStatus":"live","providerStatus":"live","providerId":"Qwen/Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","features":{"structuredOutput":true,"toolCalling":true},"isCheapestPricingOutput":false,"isFastestThroughput":true,"isModelAuthor":false,"tokensPerSecond":101.44551625043732,"pricingOutput":0.25},{"provider":"ovhcloud","modelStatus":"live","providerStatus":"live","providerId":"Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","features":{"structuredOutput":true,"toolCalling":true},"isCheapestPricingOutput":false,"isFastestThroughput":false,"isModelAuthor":false,"tokensPerSecond":35.13790098107555,"pricingOutput":0.18},{"provider":"featherless-ai","modelStatus":"live","providerStatus":"live","providerId":"Qwen/Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","isCheapestPricingOutput":false,"isFastestThroughput":false,"isModelAuthor":false},{"provider":"deepinfra","modelStatus":"live","providerStatus":"live","providerId":"Qwen/Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","features":{"structuredOutput":true,"toolCalling":true},"isCheapestPricingOutput":true,"isFastestThroughput":false,"isModelAuthor":false,"tokensPerSecond":42.263940109119496,"pricingOutput":0.15}],"showHuggingChatEntry":true,"inference":"warm","lastModified":"2026-03-02T00:51:43.000Z","likes":1860,"pipeline_tag":"image-text-to-text","library_name":"transformers","librariesOther":[],"trackDownloads":true,"model-index":null,"evalResults":[{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"mean"},"value":86.1,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Mean","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"short"},"value":92.31,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Short","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"medium"},"value":81.12,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Medium","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"long"},"value":32.22,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Long","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"Idavidrein/gpqa","isBenchmark":true,"task_id":"diamond"},"value":81.7,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false,"author":{"_id":"63e0eea7af523c37e5a77966","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/1678663263366-63e0eea7af523c37e5a77966.jpeg","fullname":"Nathan Habib","name":"SaylorTwift","type":"user","isPro":true,"isHf":true,"isHfAdmin":false,"isMod":false,"followerCount":466,"isUserFollowing":false}},"filename":".eval_results/gpqa.yaml","verified":false,"pullRequest":2,"label":"Diamond"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"overall"},"value":65.7,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Overall"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"digital"},"value":74.8,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Digital"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"photographed"},"value":62.7,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Photographed"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"latin"},"value":72.5,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Latin"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"de"},"value":72.8,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"De"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"en"},"value":72,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"En"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"es"},"value":72,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Es"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"fr"},"value":64.4,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Fr"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"id"},"value":66.2,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Id"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"it"},"value":77.6,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"It"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"nl"},"value":74.5,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Nl"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"pt"},"value":79.1,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Pt"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"vi"},"value":74,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Vi"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"non_latin"},"value":58.2,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Non Latin"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"ar"},"value":53.4,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Ar"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"hi"},"value":56.2,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Hi"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"jp"},"value":55.7,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Jp"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"ko"},"value":60.3,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Ko"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"ru"},"value":54.7,"source":{"url":"https://huggingfa","isExternal":true},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Ru"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"mean"},"value":31.9,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Mean","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"text_content"},"value":90.5,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Text Content","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"text_formatting"},"value":22,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Text Formatting","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"layout"},"value":31.8,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Layout","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"chart"},"value":5.4,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Chart","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"table"},"value":9.9,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Table","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"TIGER-Lab/MMLU-Pro","isBenchmark":true,"task_id":"mmlu_pro"},"value":82.5,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false,"author":{"_id":"63e0eea7af523c37e5a77966","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/1678663263366-63e0eea7af523c37e5a77966.jpeg","fullname":"Nathan Habib","name":"SaylorTwift","type":"user","isPro":true,"isHf":true,"isHfAdmin":false,"isMod":false,"followerCount":466,"isUserFollowing":false}},"filename":".eval_results/mmlu_pro.yaml","verified":false,"pullRequest":2,"label":"Mmlu Pro"},{"dataset":{"id":"MMMU/MMMU_Pro","isBenchmark":true,"task_id":"mmmu_pro_vision"},"value":70.1,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false},"filename":".eval_results/mmmu_pro.yaml","verified":false,"pullRequest":55,"label":"Mmmu Pro Vision"},{"dataset":{"id":"likaixin/ScreenSpot-Pro","isBenchmark":true,"task_id":"overall"},"value":65.2,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false,"author":{"_id":"6141a88b3a0ec78603c9e784","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6141a88b3a0ec78603c9e784/DJsxSmWV39M33JFheLobC.jpeg","fullname":"merve","name":"merve","type":"user","isPro":true,"isHf":true,"isHfAdmin":false,"isMod":false,"followerCount":10731,"isUserFollowing":false}},"filename":".eval_results/screenspot_pro.yaml","verified":false,"pullRequest":37,"label":"Overall"},{"dataset":{"id":"MathArena/hmmt_feb_2026","isBenchmark":true,"task_id":"MathArena/hmmt_feb_2026"},"value":71.21,"source":{"url":"https://matharena.ai/?comp=hmmt--hmmt_feb_2026","name":"Official MathArena Evaluation","isExternal":true},"filename":".eval_results/MathArena--hmmt_feb_2026.yaml","verified":false,"pullRequest":36,"label":"MathArena Hmmt Feb 2026"},{"dataset":{"id":"MathArena/aime_2026","isBenchmark":true,"task_id":"MathArena/aime_2026"},"value":92.5,"source":{"url":"https://matharena.ai/?comp=aime--aime_2026","name":"Official MathArena Evaluation","isExternal":true},"filename":".eval_results/MathArena--aime_2026.yaml","verified":false,"pullRequest":35,"label":"MathArena Aime 2026"}],"private":false,"repoType":"model","gated":false,"tags":["transformers","safetensors","qwen3_5","image-text-to-text","conversational","base_model:Qwen/Qwen3.5-9B-Base","base_model:finetune:Qwen/Qwen3.5-9B-Base","license:apache-2.0","eval-results","endpoints_compatible","deploy:sagemaker","deploy:azure","region:us"],"tag_objs":[{"id":"image-text-to-text","label":"Image-Text-to-Text","type":"pipeline_tag","subType":"multimodal"},{"id":"transformers","label":"Transformers","type":"library"},{"id":"safetensors","label":"Safetensors","type":"library"},{"id":"qwen3_5","label":"qwen3_5","type":"other","clickable":true},{"id":"conversational","label":"conversational","type":"other","clickable":true},{"id":"base_model:Qwen/Qwen3.5-9B-Base","label":"base_model:Qwen/Qwen3.5-9B-Base","type":"other","clickable":true},{"id":"base_model:finetune:Qwen/Qwen3.5-9B-Base","label":"base_model:finetune:Qwen/Qwen3.5-9B-Base","type":"other","clickable":true},{"id":"eval-results","label":"Eval Results","type":"other","clickable":true},{"id":"endpoints_compatible","label":"Inference Endpoints","type":"other","clickable":true},{"id":"license:apache-2.0","label":"apache-2.0","type":"license"},{"id":"deploy:sagemaker","label":"sagemaker","type":"deploy"},{"id":"deploy:azure","label":"azure","type":"deploy"},{"type":"region","label":"🇺🇸 Region: US","id":"region:us"}],"transformersInfo":{"auto_model":"AutoModelForMultimodalLM","pipeline_tag":"image-text-to-text","processor":"AutoProcessor"},"widgetData":[{"text":"Hi, what can you help me with?"},{"text":"What is 84 * 3 / 2?"},{"text":"Tell me an interesting fact about the universe!"},{"text":"Explain quantum computing in simple terms."}],"safetensors":{"parameters":{"BF16":9653100528,"F32":3840},"total":9653104368,"sharded":true,"totalFileSize":19306390537},"hasBlockedOids":false,"region":"us","isQuantized":false,"licenseFilePath":"LICENSE"},"inferenceContextData":{"billableEntities":[],"entityName2Providers":{},"defaultProviders":[{"isOriginalProvider":false,"name":"together","enabled":true,"position":5,"isReleased":true,"accuratePricing":true},{"isOriginalProvider":false,"name":"featherless-ai","enabled":true,"position":7,"isReleased":true,"accuratePricing":true},{"isOriginalProvider":false,"name":"ovhcloud","enabled":true,"position":14,"isReleased":true,"accuratePricing":true},{"isOriginalProvider":false,"name":"deepinfra","enabled":true,"position":16,"isReleased":true,"accuratePricing":true}]},"canWrite":false}">Safetensors[](https://huggingface.co/docs/safetensors)
Model size
10B params

Tensor type
BF16 ·
F32 ·

Chat template
Files info

<|image_pad|><|vision_end|>' }}\n {%- elif 'video' in item or item.type == 'video' %}\n {%- if is_system_content %}\n {{- raise_exception('System message cannot contain videos.') }}\n {%- endif %}\n {%- if do_vision_count %}\n {%- set video_count.value = video_count.value + 1 %}\n {%- endif %}\n {%- if add_vision_id %}\n {{- 'Video ' ~ video_count.value ~ ': ' }}\n {%- endif %}\n {{- '<|vision_start|><|video_pad|><|vision_end|>' }}\n {%- elif 'text' in item %}\n {{- item.text }}\n {%- else %}\n {{- raise_exception('Unexpected item type in content.') }}\n {%- endif %}\n {%- endfor %}\n {%- elif content is none or content is undefined %}\n {{- '' }}\n {%- else %}\n {{- raise_exception('Unexpected content type.') }}\n {%- endif %}\n{%- endmacro %}\n{%- if not messages %}\n {{- raise_exception('No messages provided.') }}\n{%- endif %}\n{%- if tools and tools is iterable and tools is not mapping %}\n {{- '<|im_start|>system\\n' }}\n {{- \"# Tools\\n\\nYou have access to the following functions:\\n\\n<tools>\" }}\n {%- for tool in tools %}\n {{- \"\\n\" }}\n {{- tool | tojson }}\n {%- endfor %}\n {{- \"\\n</tools>\" }}\n {{- '\\n\\nIf you choose to call a function ONLY reply in the following format with NO suffix:\\n\\n<tool_call>\\n<function=example_function_name>\\n<parameter=example_parameter_1>\\nvalue_1\\n</parameter>\\n<parameter=example_parameter_2>\\nThis is the value for the second parameter\\nthat can span\\nmultiple lines\\n</parameter>\\n</function>\\n</tool_call>\\n\\n<IMPORTANT>\\nReminder:\\n- Function calls MUST follow the specified format: an inner <function=...></function> block must be nested within <tool_call></tool_call> XML tags\\n- Required parameters MUST be specified\\n- You may provide optional reasoning for your function call in natural language BEFORE the function call, but NOT after\\n- If there is no function call available, answer the question like normal with your current knowledge and do not tell the user about function calls\\n</IMPORTANT>' }}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {%- if content %}\n {{- '\\n\\n' + content }}\n {%- endif %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n{%- else %}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {{- '<|im_start|>system\\n' + content + '<|im_end|>\\n' }}\n {%- endif %}\n{%- endif %}\n{%- set ns = namespace(multi_step_tool=true, last_query_index=messages|length - 1) %}\n{%- for message in messages[::-1] %}\n {%- set index = (messages|length - 1) - loop.index0 %}\n {%- if ns.multi_step_tool and message.role == \"user\" %}\n {%- set content = render_content(message.content, false)|trim %}\n {%- if not(content.startswith('<tool_response>') and content.endswith('</tool_response>')) %}\n {%- set ns.multi_step_tool = false %}\n {%- set ns.last_query_index = index %}\n {%- endif %}\n {%- endif %}\n{%- endfor %}\n{%- if ns.multi_step_tool %}\n {{- raise_exception('No user query found in messages.') }}\n{%- endif %}\n{%- for message in messages %}\n {%- set content = render_content(message.content, true)|trim %}\n {%- if message.role == \"system\" %}\n {%- if not loop.first %}\n {{- raise_exception('System message must be at the beginning.') }}\n {%- endif %}\n {%- elif message.role == \"user\" %}\n {{- '<|im_start|>' + message.role + '\\n' + content + '<|im_end|>' + '\\n' }}\n {%- elif message.role == \"assistant\" %}\n {%- set reasoning_content = '' %}\n {%- if message.reasoning_content is string %}\n {%- set reasoning_content = message.reasoning_content %}\n {%- else %}\n {%- if '</think>' in content %}\n {%- set reasoning_content = content.split('</think>')[0].rstrip('\\n').split('<think>')[-1].lstrip('\\n') %}\n {%- set content = content.split('</think>')[-1].lstrip('\\n') %}\n {%- endif %}\n {%- endif %}\n {%- set reasoning_content = reasoning_content|trim %}\n {%- if loop.index0 > ns.last_query_index %}\n {{- '<|im_start|>' + message.role + '\\n<think>\\n' + reasoning_content + '\\n</think>\\n\\n' + content }}\n {%- else %}\n {{- '<|im_start|>' + message.role + '\\n' + content }}\n {%- endif %}\n {%- if message.tool_calls and message.tool_calls is iterable and message.tool_calls is not mapping %}\n {%- for tool_call in message.tool_calls %}\n {%- if tool_call.function is defined %}\n {%- set tool_call = tool_call.function %}\n {%- endif %}\n {%- if loop.first %}\n {%- if content|trim %}\n {{- '\\n\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- else %}\n {{- '<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- else %}\n {{- '\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- if tool_call.arguments is defined %}\n {%- for args_name, args_value in tool_call.arguments|items %}\n {{- '<parameter=' + args_name + '>\\n' }}\n {%- set args_value = args_value | tojson | safe if args_value is mapping or (args_value is sequence and args_value is not string) else args_value | string %}\n {{- args_value }}\n {{- '\\n</parameter>\\n' }}\n {%- endfor %}\n {%- endif %}\n {{- '</function>\\n</tool_call>' }}\n {%- endfor %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n {%- elif message.role == \"tool\" %}\n {%- if loop.previtem and loop.previtem.role != \"tool\" %}\n {{- '<|im_start|>user' }}\n {%- endif %}\n {{- '\\n<tool_response>\\n' }}\n {{- content }}\n {{- '\\n</tool_response>' }}\n {%- if not loop.last and loop.nextitem.role != \"tool\" %}\n {{- '<|im_end|>\\n' }}\n {%- elif loop.last %}\n {{- '<|im_end|>\\n' }}\n {%- endif %}\n {%- else %}\n {{- raise_exception('Unexpected message role.') }}\n {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n {{- '<|im_start|>assistant\\n' }}\n {%- if enable_thinking is defined and enable_thinking is false %}\n {{- '<think>\\n\\n</think>\\n\\n' }}\n {%- else %}\n {{- '<think>\\n' }}\n {%- endif %}\n{%- endif %}","eos_token":"<|im_end|>","pad_token":"<|endoftext|>","unk_token":null},"chat_template_jinja":"{%- set image_count = namespace(value=0) %}\n{%- set video_count = namespace(value=0) %}\n{%- macro render_content(content, do_vision_count, is_system_content=false) %}\n {%- if content is string %}\n {{- content }}\n {%- elif content is iterable and content is not mapping %}\n {%- for item in content %}\n {%- if 'image' in item or 'image_url' in item or item.type == 'image' %}\n {%- if is_system_content %}\n {{- raise_exception('System message cannot contain images.') }}\n {%- endif %}\n {%- if do_vision_count %}\n {%- set image_count.value = image_count.value + 1 %}\n {%- endif %}\n {%- if add_vision_id %}\n {{- 'Picture ' ~ image_count.value ~ ': ' }}\n {%- endif %}\n {{- '<|vision_start|><|image_pad|><|vision_end|>' }}\n {%- elif 'video' in item or item.type == 'video' %}\n {%- if is_system_content %}\n {{- raise_exception('System message cannot contain videos.') }}\n {%- endif %}\n {%- if do_vision_count %}\n {%- set video_count.value = video_count.value + 1 %}\n {%- endif %}\n {%- if add_vision_id %}\n {{- 'Video ' ~ video_count.value ~ ': ' }}\n {%- endif %}\n {{- '<|vision_start|><|video_pad|><|vision_end|>' }}\n {%- elif 'text' in item %}\n {{- item.text }}\n {%- else %}\n {{- raise_exception('Unexpected item type in content.') }}\n {%- endif %}\n {%- endfor %}\n {%- elif content is none or content is undefined %}\n {{- '' }}\n {%- else %}\n {{- raise_exception('Unexpected content type.') }}\n {%- endif %}\n{%- endmacro %}\n{%- if not messages %}\n {{- raise_exception('No messages provided.') }}\n{%- endif %}\n{%- if tools and tools is iterable and tools is not mapping %}\n {{- '<|im_start|>system\\n' }}\n {{- \"# Tools\\n\\nYou have access to the following functions:\\n\\n<tools>\" }}\n {%- for tool in tools %}\n {{- \"\\n\" }}\n {{- tool | tojson }}\n {%- endfor %}\n {{- \"\\n</tools>\" }}\n {{- '\\n\\nIf you choose to call a function ONLY reply in the following format with NO suffix:\\n\\n<tool_call>\\n<function=example_function_name>\\n<parameter=example_parameter_1>\\nvalue_1\\n</parameter>\\n<parameter=example_parameter_2>\\nThis is the value for the second parameter\\nthat can span\\nmultiple lines\\n</parameter>\\n</function>\\n</tool_call>\\n\\n<IMPORTANT>\\nReminder:\\n- Function calls MUST follow the specified format: an inner <function=...></function> block must be nested within <tool_call></tool_call> XML tags\\n- Required parameters MUST be specified\\n- You may provide optional reasoning for your function call in natural language BEFORE the function call, but NOT after\\n- If there is no function call available, answer the question like normal with your current knowledge and do not tell the user about function calls\\n</IMPORTANT>' }}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {%- if content %}\n {{- '\\n\\n' + content }}\n {%- endif %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n{%- else %}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {{- '<|im_start|>system\\n' + content + '<|im_end|>\\n' }}\n {%- endif %}\n{%- endif %}\n{%- set ns = namespace(multi_step_tool=true, last_query_index=messages|length - 1) %}\n{%- for message in messages[::-1] %}\n {%- set index = (messages|length - 1) - loop.index0 %}\n {%- if ns.multi_step_tool and message.role == \"user\" %}\n {%- set content = render_content(message.content, false)|trim %}\n {%- if not(content.startswith('<tool_response>') and content.endswith('</tool_response>')) %}\n {%- set ns.multi_step_tool = false %}\n {%- set ns.last_query_index = index %}\n {%- endif %}\n {%- endif %}\n{%- endfor %}\n{%- if ns.multi_step_tool %}\n {{- raise_exception('No user query found in messages.') }}\n{%- endif %}\n{%- for message in messages %}\n {%- set content = render_content(message.content, true)|trim %}\n {%- if message.role == \"system\" %}\n {%- if not loop.first %}\n {{- raise_exception('System message must be at the beginning.') }}\n {%- endif %}\n {%- elif message.role == \"user\" %}\n {{- '<|im_start|>' + message.role + '\\n' + content + '<|im_end|>' + '\\n' }}\n {%- elif message.role == \"assistant\" %}\n {%- set reasoning_content = '' %}\n {%- if message.reasoning_content is string %}\n {%- set reasoning_content = message.reasoning_content %}\n {%- else %}\n {%- if '</think>' in content %}\n {%- set reasoning_content = content.split('</think>')[0].rstrip('\\n').split('<think>')[-1].lstrip('\\n') %}\n {%- set content = content.split('</think>')[-1].lstrip('\\n') %}\n {%- endif %}\n {%- endif %}\n {%- set reasoning_content = reasoning_content|trim %}\n {%- if loop.index0 > ns.last_query_index %}\n {{- '<|im_start|>' + message.role + '\\n<think>\\n' + reasoning_content + '\\n</think>\\n\\n' + content }}\n {%- else %}\n {{- '<|im_start|>' + message.role + '\\n' + content }}\n {%- endif %}\n {%- if message.tool_calls and message.tool_calls is iterable and message.tool_calls is not mapping %}\n {%- for tool_call in message.tool_calls %}\n {%- if tool_call.function is defined %}\n {%- set tool_call = tool_call.function %}\n {%- endif %}\n {%- if loop.first %}\n {%- if content|trim %}\n {{- '\\n\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- else %}\n {{- '<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- else %}\n {{- '\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- if tool_call.arguments is defined %}\n {%- for args_name, args_value in tool_call.arguments|items %}\n {{- '<parameter=' + args_name + '>\\n' }}\n {%- set args_value = args_value | tojson | safe if args_value is mapping or (args_value is sequence and args_value is not string) else args_value | string %}\n {{- args_value }}\n {{- '\\n</parameter>\\n' }}\n {%- endfor %}\n {%- endif %}\n {{- '</function>\\n</tool_call>' }}\n {%- endfor %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n {%- elif message.role == \"tool\" %}\n {%- if loop.previtem and loop.previtem.role != \"tool\" %}\n {{- '<|im_start|>user' }}\n {%- endif %}\n {{- '\\n<tool_response>\\n' }}\n {{- content }}\n {{- '\\n</tool_response>' }}\n {%- if not loop.last and loop.nextitem.role != \"tool\" %}\n {{- '<|im_end|>\\n' }}\n {%- elif loop.last %}\n {{- '<|im_end|>\\n' }}\n {%- endif %}\n {%- else %}\n {{- raise_exception('Unexpected message role.') }}\n {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n {{- '<|im_start|>assistant\\n' }}\n {%- if enable_thinking is defined and enable_thinking is false %}\n {{- '<think>\\n\\n</think>\\n\\n' }}\n {%- else %}\n {{- '<think>\\n' }}\n {%- endif %}\n{%- endif %}"},"createdAt":"2026-02-27T12:58:26.000Z","discussionsDisabled":false,"discussionsSorting":"recently-created","downloads":13442398,"downloadsAllTime":55389227,"id":"Qwen/Qwen3.5-9B","isLikedByUser":false,"availableInferenceProviders":[{"provider":"together","modelStatus":"live","providerStatus":"live","providerId":"Qwen/Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","features":{"structuredOutput":true,"toolCalling":true},"isCheapestPricingOutput":false,"isFastestThroughput":true,"isModelAuthor":false,"tokensPerSecond":101.44551625043732,"pricingOutput":0.25},{"provider":"ovhcloud","modelStatus":"live","providerStatus":"live","providerId":"Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","features":{"structuredOutput":true,"toolCalling":true},"isCheapestPricingOutput":false,"isFastestThroughput":false,"isModelAuthor":false,"tokensPerSecond":35.13790098107555,"pricingOutput":0.18},{"provider":"featherless-ai","modelStatus":"live","providerStatus":"live","providerId":"Qwen/Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","isCheapestPricingOutput":false,"isFastestThroughput":false,"isModelAuthor":false},{"provider":"deepinfra","modelStatus":"live","providerStatus":"live","providerId":"Qwen/Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","features":{"structuredOutput":true,"toolCalling":true},"isCheapestPricingOutput":true,"isFastestThroughput":false,"isModelAuthor":false,"tokensPerSecond":42.263940109119496,"pricingOutput":0.15}],"showHuggingChatEntry":true,"inference":"warm","lastModified":"2026-03-02T00:51:43.000Z","likes":1860,"pipeline_tag":"image-text-to-text","library_name":"transformers","librariesOther":[],"trackDownloads":true,"model-index":null,"evalResults":[{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"mean"},"value":86.1,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Mean","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"short"},"value":92.31,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Short","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"medium"},"value":81.12,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Medium","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"long"},"value":32.22,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Long","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"Idavidrein/gpqa","isBenchmark":true,"task_id":"diamond"},"value":81.7,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false,"author":{"_id":"63e0eea7af523c37e5a77966","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/1678663263366-63e0eea7af523c37e5a77966.jpeg","fullname":"Nathan Habib","name":"SaylorTwift","type":"user","isPro":true,"isHf":true,"isHfAdmin":false,"isMod":false,"followerCount":466,"isUserFollowing":false}},"filename":".eval_results/gpqa.yaml","verified":false,"pullRequest":2,"label":"Diamond"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"overall"},"value":65.7,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Overall"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"digital"},"value":74.8,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Digital"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"photographed"},"value":62.7,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Photographed"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"latin"},"value":72.5,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Latin"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"de"},"value":72.8,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"De"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"en"},"value":72,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"En"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"es"},"value":72,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Es"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"fr"},"value":64.4,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Fr"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"id"},"value":66.2,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Id"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"it"},"value":77.6,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"It"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"nl"},"value":74.5,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Nl"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"pt"},"value":79.1,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Pt"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"vi"},"value":74,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Vi"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"non_latin"},"value":58.2,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Non Latin"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"ar"},"value":53.4,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Ar"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"hi"},"value":56.2,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Hi"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"jp"},"value":55.7,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Jp"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"ko"},"value":60.3,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Ko"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"ru"},"value":54.7,"source":{"url":"https://huggingfa","isExternal":true},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Ru"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"mean"},"value":31.9,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Mean","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"text_content"},"value":90.5,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Text Content","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"text_formatting"},"value":22,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Text Formatting","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"layout"},"value":31.8,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Layout","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"chart"},"value":5.4,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Chart","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"table"},"value":9.9,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Table","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"TIGER-Lab/MMLU-Pro","isBenchmark":true,"task_id":"mmlu_pro"},"value":82.5,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false,"author":{"_id":"63e0eea7af523c37e5a77966","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/1678663263366-63e0eea7af523c37e5a77966.jpeg","fullname":"Nathan Habib","name":"SaylorTwift","type":"user","isPro":true,"isHf":true,"isHfAdmin":false,"isMod":false,"followerCount":466,"isUserFollowing":false}},"filename":".eval_results/mmlu_pro.yaml","verified":false,"pullRequest":2,"label":"Mmlu Pro"},{"dataset":{"id":"MMMU/MMMU_Pro","isBenchmark":true,"task_id":"mmmu_pro_vision"},"value":70.1,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false},"filename":".eval_results/mmmu_pro.yaml","verified":false,"pullRequest":55,"label":"Mmmu Pro Vision"},{"dataset":{"id":"likaixin/ScreenSpot-Pro","isBenchmark":true,"task_id":"overall"},"value":65.2,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false,"author":{"_id":"6141a88b3a0ec78603c9e784","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6141a88b3a0ec78603c9e784/DJsxSmWV39M33JFheLobC.jpeg","fullname":"merve","name":"merve","type":"user","isPro":true,"isHf":true,"isHfAdmin":false,"isMod":false,"followerCount":10731,"isUserFollowing":false}},"filename":".eval_results/screenspot_pro.yaml","verified":false,"pullRequest":37,"label":"Overall"},{"dataset":{"id":"MathArena/hmmt_feb_2026","isBenchmark":true,"task_id":"MathArena/hmmt_feb_2026"},"value":71.21,"source":{"url":"https://matharena.ai/?comp=hmmt--hmmt_feb_2026","name":"Official MathArena Evaluation","isExternal":true},"filename":".eval_results/MathArena--hmmt_feb_2026.yaml","verified":false,"pullRequest":36,"label":"MathArena Hmmt Feb 2026"},{"dataset":{"id":"MathArena/aime_2026","isBenchmark":true,"task_id":"MathArena/aime_2026"},"value":92.5,"source":{"url":"https://matharena.ai/?comp=aime--aime_2026","name":"Official MathArena Evaluation","isExternal":true},"filename":".eval_results/MathArena--aime_2026.yaml","verified":false,"pullRequest":35,"label":"MathArena Aime 2026"}],"private":false,"repoType":"model","gated":false,"tags":["transformers","safetensors","qwen3_5","image-text-to-text","conversational","base_model:Qwen/Qwen3.5-9B-Base","base_model:finetune:Qwen/Qwen3.5-9B-Base","license:apache-2.0","eval-results","endpoints_compatible","deploy:sagemaker","deploy:azure","region:us"],"tag_objs":[{"id":"image-text-to-text","label":"Image-Text-to-Text","type":"pipeline_tag","subType":"multimodal"},{"id":"transformers","label":"Transformers","type":"library"},{"id":"safetensors","label":"Safetensors","type":"library"},{"id":"qwen3_5","label":"qwen3_5","type":"other","clickable":true},{"id":"conversational","label":"conversational","type":"other","clickable":true},{"id":"base_model:Qwen/Qwen3.5-9B-Base","label":"base_model:Qwen/Qwen3.5-9B-Base","type":"other","clickable":true},{"id":"base_model:finetune:Qwen/Qwen3.5-9B-Base","label":"base_model:finetune:Qwen/Qwen3.5-9B-Base","type":"other","clickable":true},{"id":"eval-results","label":"Eval Results","type":"other","clickable":true},{"id":"endpoints_compatible","label":"Inference Endpoints","type":"other","clickable":true},{"id":"license:apache-2.0","label":"apache-2.0","type":"license"},{"id":"deploy:sagemaker","label":"sagemaker","type":"deploy"},{"id":"deploy:azure","label":"azure","type":"deploy"},{"type":"region","label":"🇺🇸 Region: US","id":"region:us"}],"transformersInfo":{"auto_model":"AutoModelForMultimodalLM","pipeline_tag":"image-text-to-text","processor":"AutoProcessor"},"widgetData":[{"text":"Hi, what can you help me with?"},{"text":"What is 84 * 3 / 2?"},{"text":"Tell me an interesting fact about the universe!"},{"text":"Explain quantum computing in simple terms."}],"safetensors":{"parameters":{"BF16":9653100528,"F32":3840},"total":9653104368,"sharded":true,"totalFileSize":19306390537},"hasBlockedOids":false,"region":"us","isQuantized":false,"licenseFilePath":"LICENSE"},"queryParams":{},"inferenceContextData":{"billableEntities":[],"entityName2Providers":{},"defaultProviders":[{"isOriginalProvider":false,"name":"together","enabled":true,"position":5,"isReleased":true,"accuratePricing":true},{"isOriginalProvider":false,"name":"featherless-ai","enabled":true,"position":7,"isReleased":true,"accuratePricing":true},{"isOriginalProvider":false,"name":"ovhcloud","enabled":true,"position":14,"isReleased":true,"accuratePricing":true},{"isOriginalProvider":false,"name":"deepinfra","enabled":true,"position":16,"isReleased":true,"accuratePricing":true}]},"linkToInferenceDiscussion":{"url":"/spaces/huggingface/InferenceSupport/discussions/8361","numReactions":52},"isLoggedIn":false,"canWrite":false,"examples":[{"text":"Hi, what can you help me with?"},{"text":"What is 84 * 3 / 2?"},{"text":"Tell me an interesting fact about the universe!"},{"text":"Explain quantum computing in simple terms."}],"initialSelectedProvider":"together","widgetType":"conversational","isMaximized":false,"isMac":false}}"> Inference Providers [NEW](https://huggingface.co/docs/inference-providers)
Together AI

-
-
- +1

[ Image-Text-to-Text
](/tasks/image-text-to-text)
Examples

Input a message to start chatting with Qwen/Qwen3.5-9B.

Send

View Code Snippets

[ Compare providers](/inference/models?model=Qwen%2FQwen3.5-9B)

## Model tree for Qwen/Qwen3.5-9B [](/docs/hub/model-cards#specifying-a-base-model)
Base model

[Qwen/Qwen3.5-9B-Base](/Qwen/Qwen3.5-9B-Base)

Finetuned
([428](/models?other=base_model:finetune:Qwen/Qwen3.5-9B-Base))
this model

Adapters

[578 models](/models?other=base_model:adapter:Qwen/Qwen3.5-9B)

Finetunes

[669 models](/models?other=base_model:finetune:Qwen/Qwen3.5-9B)

Merges

[17 models](/models?other=base_model:merge:Qwen/Qwen3.5-9B)

Quantizations

[](/models?apps=llama.cpp&other=base_model:quantized:Qwen/Qwen3.5-9B)[](/models?apps=lmstudio&other=base_model:quantized:Qwen/Qwen3.5-9B)[](/models?apps=jan&other=base_model:quantized:Qwen/Qwen3.5-9B)[](/models?apps=ollama&other=base_model:quantized:Qwen/Qwen3.5-9B)
[472 models](/models?other=base_model:quantized:Qwen/Qwen3.5-9B)

## Spaces using Qwen/Qwen3.5-9B 100
[💥
pliny-the-prompter/obliteratus
](/spaces/pliny-the-prompter/obliteratus)[📖
finebooks/bhl-ocr-leaderboard
](/spaces/finebooks/bhl-ocr-leaderboard)[🚀
FINAL-Bench/all-bench-leaderboard
](/spaces/FINAL-Bench/all-bench-leaderboard)[🤖
artificialguybr/qwen-chat-demo

](/spaces/artificialguybr/qwen-chat-demo)[📈
ginigen-ai/smol-worldcup
](/spaces/ginigen-ai/smol-worldcup)[🧠
ginigen-ai/Metacognition-Leaderboard-Space
](/spaces/ginigen-ai/Metacognition-Leaderboard-Space)[🔥
prithivMLmods/NAVA-Text-to-Video
](/spaces/prithivMLmods/NAVA-Text-to-Video)[📊
EuroEval/euroeval_leaderboard
](/spaces/EuroEval/euroeval_leaderboard) + 95 Spaces + 92 Spaces

## Collection including Qwen/Qwen3.5-9B
[
#### Qwen3.5
Collection

21 items • Updated Mar 9 • 1.76k
](/collections/Qwen/qwen35)

<|image_pad|><|vision_end|>' }}\n {%- elif 'video' in item or item.type == 'video' %}\n {%- if is_system_content %}\n {{- raise_exception('System message cannot contain videos.') }}\n {%- endif %}\n {%- if do_vision_count %}\n {%- set video_count.value = video_count.value + 1 %}\n {%- endif %}\n {%- if add_vision_id %}\n {{- 'Video ' ~ video_count.value ~ ': ' }}\n {%- endif %}\n {{- '<|vision_start|><|video_pad|><|vision_end|>' }}\n {%- elif 'text' in item %}\n {{- item.text }}\n {%- else %}\n {{- raise_exception('Unexpected item type in content.') }}\n {%- endif %}\n {%- endfor %}\n {%- elif content is none or content is undefined %}\n {{- '' }}\n {%- else %}\n {{- raise_exception('Unexpected content type.') }}\n {%- endif %}\n{%- endmacro %}\n{%- if not messages %}\n {{- raise_exception('No messages provided.') }}\n{%- endif %}\n{%- if tools and tools is iterable and tools is not mapping %}\n {{- '<|im_start|>system\\n' }}\n {{- \"# Tools\\n\\nYou have access to the following functions:\\n\\n<tools>\" }}\n {%- for tool in tools %}\n {{- \"\\n\" }}\n {{- tool | tojson }}\n {%- endfor %}\n {{- \"\\n</tools>\" }}\n {{- '\\n\\nIf you choose to call a function ONLY reply in the following format with NO suffix:\\n\\n<tool_call>\\n<function=example_function_name>\\n<parameter=example_parameter_1>\\nvalue_1\\n</parameter>\\n<parameter=example_parameter_2>\\nThis is the value for the second parameter\\nthat can span\\nmultiple lines\\n</parameter>\\n</function>\\n</tool_call>\\n\\n<IMPORTANT>\\nReminder:\\n- Function calls MUST follow the specified format: an inner <function=...></function> block must be nested within <tool_call></tool_call> XML tags\\n- Required parameters MUST be specified\\n- You may provide optional reasoning for your function call in natural language BEFORE the function call, but NOT after\\n- If there is no function call available, answer the question like normal with your current knowledge and do not tell the user about function calls\\n</IMPORTANT>' }}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {%- if content %}\n {{- '\\n\\n' + content }}\n {%- endif %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n{%- else %}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {{- '<|im_start|>system\\n' + content + '<|im_end|>\\n' }}\n {%- endif %}\n{%- endif %}\n{%- set ns = namespace(multi_step_tool=true, last_query_index=messages|length - 1) %}\n{%- for message in messages[::-1] %}\n {%- set index = (messages|length - 1) - loop.index0 %}\n {%- if ns.multi_step_tool and message.role == \"user\" %}\n {%- set content = render_content(message.content, false)|trim %}\n {%- if not(content.startswith('<tool_response>') and content.endswith('</tool_response>')) %}\n {%- set ns.multi_step_tool = false %}\n {%- set ns.last_query_index = index %}\n {%- endif %}\n {%- endif %}\n{%- endfor %}\n{%- if ns.multi_step_tool %}\n {{- raise_exception('No user query found in messages.') }}\n{%- endif %}\n{%- for message in messages %}\n {%- set content = render_content(message.content, true)|trim %}\n {%- if message.role == \"system\" %}\n {%- if not loop.first %}\n {{- raise_exception('System message must be at the beginning.') }}\n {%- endif %}\n {%- elif message.role == \"user\" %}\n {{- '<|im_start|>' + message.role + '\\n' + content + '<|im_end|>' + '\\n' }}\n {%- elif message.role == \"assistant\" %}\n {%- set reasoning_content = '' %}\n {%- if message.reasoning_content is string %}\n {%- set reasoning_content = message.reasoning_content %}\n {%- else %}\n {%- if '</think>' in content %}\n {%- set reasoning_content = content.split('</think>')[0].rstrip('\\n').split('<think>')[-1].lstrip('\\n') %}\n {%- set content = content.split('</think>')[-1].lstrip('\\n') %}\n {%- endif %}\n {%- endif %}\n {%- set reasoning_content = reasoning_content|trim %}\n {%- if loop.index0 > ns.last_query_index %}\n {{- '<|im_start|>' + message.role + '\\n<think>\\n' + reasoning_content + '\\n</think>\\n\\n' + content }}\n {%- else %}\n {{- '<|im_start|>' + message.role + '\\n' + content }}\n {%- endif %}\n {%- if message.tool_calls and message.tool_calls is iterable and message.tool_calls is not mapping %}\n {%- for tool_call in message.tool_calls %}\n {%- if tool_call.function is defined %}\n {%- set tool_call = tool_call.function %}\n {%- endif %}\n {%- if loop.first %}\n {%- if content|trim %}\n {{- '\\n\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- else %}\n {{- '<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- else %}\n {{- '\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- if tool_call.arguments is defined %}\n {%- for args_name, args_value in tool_call.arguments|items %}\n {{- '<parameter=' + args_name + '>\\n' }}\n {%- set args_value = args_value | tojson | safe if args_value is mapping or (args_value is sequence and args_value is not string) else args_value | string %}\n {{- args_value }}\n {{- '\\n</parameter>\\n' }}\n {%- endfor %}\n {%- endif %}\n {{- '</function>\\n</tool_call>' }}\n {%- endfor %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n {%- elif message.role == \"tool\" %}\n {%- if loop.previtem and loop.previtem.role != \"tool\" %}\n {{- '<|im_start|>user' }}\n {%- endif %}\n {{- '\\n<tool_response>\\n' }}\n {{- content }}\n {{- '\\n</tool_response>' }}\n {%- if not loop.last and loop.nextitem.role != \"tool\" %}\n {{- '<|im_end|>\\n' }}\n {%- elif loop.last %}\n {{- '<|im_end|>\\n' }}\n {%- endif %}\n {%- else %}\n {{- raise_exception('Unexpected message role.') }}\n {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n {{- '<|im_start|>assistant\\n' }}\n {%- if enable_thinking is defined and enable_thinking is false %}\n {{- '<think>\\n\\n</think>\\n\\n' }}\n {%- else %}\n {{- '<think>\\n' }}\n {%- endif %}\n{%- endif %}","eos_token":"<|im_end|>","pad_token":"<|endoftext|>","unk_token":null},"chat_template_jinja":"{%- set image_count = namespace(value=0) %}\n{%- set video_count = namespace(value=0) %}\n{%- macro render_content(content, do_vision_count, is_system_content=false) %}\n {%- if content is string %}\n {{- content }}\n {%- elif content is iterable and content is not mapping %}\n {%- for item in content %}\n {%- if 'image' in item or 'image_url' in item or item.type == 'image' %}\n {%- if is_system_content %}\n {{- raise_exception('System message cannot contain images.') }}\n {%- endif %}\n {%- if do_vision_count %}\n {%- set image_count.value = image_count.value + 1 %}\n {%- endif %}\n {%- if add_vision_id %}\n {{- 'Picture ' ~ image_count.value ~ ': ' }}\n {%- endif %}\n {{- '<|vision_start|><|image_pad|><|vision_end|>' }}\n {%- elif 'video' in item or item.type == 'video' %}\n {%- if is_system_content %}\n {{- raise_exception('System message cannot contain videos.') }}\n {%- endif %}\n {%- if do_vision_count %}\n {%- set video_count.value = video_count.value + 1 %}\n {%- endif %}\n {%- if add_vision_id %}\n {{- 'Video ' ~ video_count.value ~ ': ' }}\n {%- endif %}\n {{- '<|vision_start|><|video_pad|><|vision_end|>' }}\n {%- elif 'text' in item %}\n {{- item.text }}\n {%- else %}\n {{- raise_exception('Unexpected item type in content.') }}\n {%- endif %}\n {%- endfor %}\n {%- elif content is none or content is undefined %}\n {{- '' }}\n {%- else %}\n {{- raise_exception('Unexpected content type.') }}\n {%- endif %}\n{%- endmacro %}\n{%- if not messages %}\n {{- raise_exception('No messages provided.') }}\n{%- endif %}\n{%- if tools and tools is iterable and tools is not mapping %}\n {{- '<|im_start|>system\\n' }}\n {{- \"# Tools\\n\\nYou have access to the following functions:\\n\\n<tools>\" }}\n {%- for tool in tools %}\n {{- \"\\n\" }}\n {{- tool | tojson }}\n {%- endfor %}\n {{- \"\\n</tools>\" }}\n {{- '\\n\\nIf you choose to call a function ONLY reply in the following format with NO suffix:\\n\\n<tool_call>\\n<function=example_function_name>\\n<parameter=example_parameter_1>\\nvalue_1\\n</parameter>\\n<parameter=example_parameter_2>\\nThis is the value for the second parameter\\nthat can span\\nmultiple lines\\n</parameter>\\n</function>\\n</tool_call>\\n\\n<IMPORTANT>\\nReminder:\\n- Function calls MUST follow the specified format: an inner <function=...></function> block must be nested within <tool_call></tool_call> XML tags\\n- Required parameters MUST be specified\\n- You may provide optional reasoning for your function call in natural language BEFORE the function call, but NOT after\\n- If there is no function call available, answer the question like normal with your current knowledge and do not tell the user about function calls\\n</IMPORTANT>' }}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {%- if content %}\n {{- '\\n\\n' + content }}\n {%- endif %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n{%- else %}\n {%- if messages[0].role == 'system' %}\n {%- set content = render_content(messages[0].content, false, true)|trim %}\n {{- '<|im_start|>system\\n' + content + '<|im_end|>\\n' }}\n {%- endif %}\n{%- endif %}\n{%- set ns = namespace(multi_step_tool=true, last_query_index=messages|length - 1) %}\n{%- for message in messages[::-1] %}\n {%- set index = (messages|length - 1) - loop.index0 %}\n {%- if ns.multi_step_tool and message.role == \"user\" %}\n {%- set content = render_content(message.content, false)|trim %}\n {%- if not(content.startswith('<tool_response>') and content.endswith('</tool_response>')) %}\n {%- set ns.multi_step_tool = false %}\n {%- set ns.last_query_index = index %}\n {%- endif %}\n {%- endif %}\n{%- endfor %}\n{%- if ns.multi_step_tool %}\n {{- raise_exception('No user query found in messages.') }}\n{%- endif %}\n{%- for message in messages %}\n {%- set content = render_content(message.content, true)|trim %}\n {%- if message.role == \"system\" %}\n {%- if not loop.first %}\n {{- raise_exception('System message must be at the beginning.') }}\n {%- endif %}\n {%- elif message.role == \"user\" %}\n {{- '<|im_start|>' + message.role + '\\n' + content + '<|im_end|>' + '\\n' }}\n {%- elif message.role == \"assistant\" %}\n {%- set reasoning_content = '' %}\n {%- if message.reasoning_content is string %}\n {%- set reasoning_content = message.reasoning_content %}\n {%- else %}\n {%- if '</think>' in content %}\n {%- set reasoning_content = content.split('</think>')[0].rstrip('\\n').split('<think>')[-1].lstrip('\\n') %}\n {%- set content = content.split('</think>')[-1].lstrip('\\n') %}\n {%- endif %}\n {%- endif %}\n {%- set reasoning_content = reasoning_content|trim %}\n {%- if loop.index0 > ns.last_query_index %}\n {{- '<|im_start|>' + message.role + '\\n<think>\\n' + reasoning_content + '\\n</think>\\n\\n' + content }}\n {%- else %}\n {{- '<|im_start|>' + message.role + '\\n' + content }}\n {%- endif %}\n {%- if message.tool_calls and message.tool_calls is iterable and message.tool_calls is not mapping %}\n {%- for tool_call in message.tool_calls %}\n {%- if tool_call.function is defined %}\n {%- set tool_call = tool_call.function %}\n {%- endif %}\n {%- if loop.first %}\n {%- if content|trim %}\n {{- '\\n\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- else %}\n {{- '<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- else %}\n {{- '\\n<tool_call>\\n<function=' + tool_call.name + '>\\n' }}\n {%- endif %}\n {%- if tool_call.arguments is defined %}\n {%- for args_name, args_value in tool_call.arguments|items %}\n {{- '<parameter=' + args_name + '>\\n' }}\n {%- set args_value = args_value | tojson | safe if args_value is mapping or (args_value is sequence and args_value is not string) else args_value | string %}\n {{- args_value }}\n {{- '\\n</parameter>\\n' }}\n {%- endfor %}\n {%- endif %}\n {{- '</function>\\n</tool_call>' }}\n {%- endfor %}\n {%- endif %}\n {{- '<|im_end|>\\n' }}\n {%- elif message.role == \"tool\" %}\n {%- if loop.previtem and loop.previtem.role != \"tool\" %}\n {{- '<|im_start|>user' }}\n {%- endif %}\n {{- '\\n<tool_response>\\n' }}\n {{- content }}\n {{- '\\n</tool_response>' }}\n {%- if not loop.last and loop.nextitem.role != \"tool\" %}\n {{- '<|im_end|>\\n' }}\n {%- elif loop.last %}\n {{- '<|im_end|>\\n' }}\n {%- endif %}\n {%- else %}\n {{- raise_exception('Unexpected message role.') }}\n {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n {{- '<|im_start|>assistant\\n' }}\n {%- if enable_thinking is defined and enable_thinking is false %}\n {{- '<think>\\n\\n</think>\\n\\n' }}\n {%- else %}\n {{- '<think>\\n' }}\n {%- endif %}\n{%- endif %}"},"createdAt":"2026-02-27T12:58:26.000Z","discussionsDisabled":false,"discussionsSorting":"recently-created","downloads":13442398,"downloadsAllTime":55389227,"id":"Qwen/Qwen3.5-9B","isLikedByUser":false,"availableInferenceProviders":[{"provider":"together","modelStatus":"live","providerStatus":"live","providerId":"Qwen/Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","features":{"structuredOutput":true,"toolCalling":true},"isCheapestPricingOutput":false,"isFastestThroughput":true,"isModelAuthor":false,"tokensPerSecond":101.44551625043732,"pricingOutput":0.25},{"provider":"ovhcloud","modelStatus":"live","providerStatus":"live","providerId":"Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","features":{"structuredOutput":true,"toolCalling":true},"isCheapestPricingOutput":false,"isFastestThroughput":false,"isModelAuthor":false,"tokensPerSecond":35.13790098107555,"pricingOutput":0.18},{"provider":"featherless-ai","modelStatus":"live","providerStatus":"live","providerId":"Qwen/Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","isCheapestPricingOutput":false,"isFastestThroughput":false,"isModelAuthor":false},{"provider":"deepinfra","modelStatus":"live","providerStatus":"live","providerId":"Qwen/Qwen3.5-9B","task":"conversational","adapterWeightsPath":"model.safetensors-00001-of-00004.safetensors","features":{"structuredOutput":true,"toolCalling":true},"isCheapestPricingOutput":true,"isFastestThroughput":false,"isModelAuthor":false,"tokensPerSecond":42.263940109119496,"pricingOutput":0.15}],"showHuggingChatEntry":true,"inference":"warm","lastModified":"2026-03-02T00:51:43.000Z","likes":1860,"pipeline_tag":"image-text-to-text","library_name":"transformers","librariesOther":[],"trackDownloads":true,"model-index":null,"evalResults":[{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"mean"},"value":86.1,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Mean","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"short"},"value":92.31,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Short","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"medium"},"value":81.12,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Medium","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"llamaindex/ExtractBench","isBenchmark":true,"task_id":"long"},"value":32.22,"source":{"url":"https://huggingface.co/datasets/llamaindex/ExtractBench","name":"ExtractBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/extractbench.yaml","verified":false,"pullRequest":67,"label":"Long","notes":"Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file"},{"dataset":{"id":"Idavidrein/gpqa","isBenchmark":true,"task_id":"diamond"},"value":81.7,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false,"author":{"_id":"63e0eea7af523c37e5a77966","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/1678663263366-63e0eea7af523c37e5a77966.jpeg","fullname":"Nathan Habib","name":"SaylorTwift","type":"user","isPro":true,"isHf":true,"isHfAdmin":false,"isMod":false,"followerCount":466,"isUserFollowing":false}},"filename":".eval_results/gpqa.yaml","verified":false,"pullRequest":2,"label":"Diamond"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"overall"},"value":65.7,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Overall"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"digital"},"value":74.8,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Digital"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"photographed"},"value":62.7,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Photographed"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"latin"},"value":72.5,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Latin"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"de"},"value":72.8,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"De"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"en"},"value":72,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"En"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"es"},"value":72,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Es"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"fr"},"value":64.4,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Fr"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"id"},"value":66.2,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Id"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"it"},"value":77.6,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"It"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"nl"},"value":74.5,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Nl"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"pt"},"value":79.1,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Pt"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"vi"},"value":74,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Vi"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"non_latin"},"value":58.2,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Non Latin"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"ar"},"value":53.4,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Ar"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"hi"},"value":56.2,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Hi"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"jp"},"value":55.7,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Jp"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"ko"},"value":60.3,"source":{"url":"https://huggingface.co/datasets/Delores-Lin/MDPBench","name":"MDPBench leaderboard","isExternal":true,"author":{"_id":"687a14565d8f9617af6ab38b","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/no-auth/LgZxNkDzfdr9DP6tqb8bh.png","fullname":"Delores Lin","name":"Delores-Lin","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":1,"isUserFollowing":false}},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Ko"},{"dataset":{"id":"Delores-Lin/MDPBench","isBenchmark":true,"task_id":"ru"},"value":54.7,"source":{"url":"https://huggingfa","isExternal":true},"filename":".eval_results/mdpbench.yaml","verified":false,"pullRequest":50,"label":"Ru"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"mean"},"value":31.9,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Mean","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"text_content"},"value":90.5,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Text Content","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"text_formatting"},"value":22,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Text Formatting","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"layout"},"value":31.8,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Layout","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"chart"},"value":5.4,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Chart","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"llamaindex/ParseBench","isBenchmark":true,"task_id":"table"},"value":9.9,"source":{"url":"https://huggingface.co/datasets/llamaindex/ParseBench","name":"ParseBench","isExternal":true,"author":{"_id":"6980fe7cc9e5d7013d527b3a","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6980fe7cc9e5d7013d527b3a/F5Z_0zjcdl0cIKIq-MvTR.jpeg","fullname":"Boyang Zhang","name":"boyang-runllama","type":"user","isPro":false,"isHf":false,"isHfAdmin":false,"isMod":false,"followerCount":2,"isUserFollowing":false}},"filename":".eval_results/parsebench.yaml","verified":false,"pullRequest":53,"label":"Table","notes":"Pipeline name: qwen3_5_9b_vllm_layout"},{"dataset":{"id":"TIGER-Lab/MMLU-Pro","isBenchmark":true,"task_id":"mmlu_pro"},"value":82.5,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false,"author":{"_id":"63e0eea7af523c37e5a77966","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/1678663263366-63e0eea7af523c37e5a77966.jpeg","fullname":"Nathan Habib","name":"SaylorTwift","type":"user","isPro":true,"isHf":true,"isHfAdmin":false,"isMod":false,"followerCount":466,"isUserFollowing":false}},"filename":".eval_results/mmlu_pro.yaml","verified":false,"pullRequest":2,"label":"Mmlu Pro"},{"dataset":{"id":"MMMU/MMMU_Pro","isBenchmark":true,"task_id":"mmmu_pro_vision"},"value":70.1,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false},"filename":".eval_results/mmmu_pro.yaml","verified":false,"pullRequest":55,"label":"Mmmu Pro Vision"},{"dataset":{"id":"likaixin/ScreenSpot-Pro","isBenchmark":true,"task_id":"overall"},"value":65.2,"source":{"url":"https://huggingface.co/Qwen/Qwen3.5-9B","name":"Model Card","isExternal":false,"author":{"_id":"6141a88b3a0ec78603c9e784","avatarUrl":"https://cdn-avatars.huggingface.co/v1/production/uploads/6141a88b3a0ec78603c9e784/DJsxSmWV39M33JFheLobC.jpeg","fullname":"merve","name":"merve","type":"user","isPro":true,"isHf":true,"isHfAdmin":false,"isMod":false,"followerCount":10731,"isUserFollowing":false}},"filename":".eval_results/screenspot_pro.yaml","verified":false,"pullRequest":37,"label":"Overall"},{"dataset":{"id":"MathArena/hmmt_feb_2026","isBenchmark":true,"task_id":"MathArena/hmmt_feb_2026"},"value":71.21,"source":{"url":"https://matharena.ai/?comp=hmmt--hmmt_feb_2026","name":"Official MathArena Evaluation","isExternal":true},"filename":".eval_results/MathArena--hmmt_feb_2026.yaml","verified":false,"pullRequest":36,"label":"MathArena Hmmt Feb 2026"},{"dataset":{"id":"MathArena/aime_2026","isBenchmark":true,"task_id":"MathArena/aime_2026"},"value":92.5,"source":{"url":"https://matharena.ai/?comp=aime--aime_2026","name":"Official MathArena Evaluation","isExternal":true},"filename":".eval_results/MathArena--aime_2026.yaml","verified":false,"pullRequest":35,"label":"MathArena Aime 2026"}],"private":false,"repoType":"model","gated":false,"tags":["transformers","safetensors","qwen3_5","image-text-to-text","conversational","base_model:Qwen/Qwen3.5-9B-Base","base_model:finetune:Qwen/Qwen3.5-9B-Base","license:apache-2.0","eval-results","endpoints_compatible","deploy:sagemaker","deploy:azure","region:us"],"tag_objs":[{"id":"image-text-to-text","label":"Image-Text-to-Text","type":"pipeline_tag","subType":"multimodal"},{"id":"transformers","label":"Transformers","type":"library"},{"id":"safetensors","label":"Safetensors","type":"library"},{"id":"qwen3_5","label":"qwen3_5","type":"other","clickable":true},{"id":"conversational","label":"conversational","type":"other","clickable":true},{"id":"base_model:Qwen/Qwen3.5-9B-Base","label":"base_model:Qwen/Qwen3.5-9B-Base","type":"other","clickable":true},{"id":"base_model:finetune:Qwen/Qwen3.5-9B-Base","label":"base_model:finetune:Qwen/Qwen3.5-9B-Base","type":"other","clickable":true},{"id":"eval-results","label":"Eval Results","type":"other","clickable":true},{"id":"endpoints_compatible","label":"Inference Endpoints","type":"other","clickable":true},{"id":"license:apache-2.0","label":"apache-2.0","type":"license"},{"id":"deploy:sagemaker","label":"sagemaker","type":"deploy"},{"id":"deploy:azure","label":"azure","type":"deploy"},{"type":"region","label":"🇺🇸 Region: US","id":"region:us"}],"transformersInfo":{"auto_model":"AutoModelForMultimodalLM","pipeline_tag":"image-text-to-text","processor":"AutoProcessor"},"widgetData":[{"text":"Hi, what can you help me with?"},{"text":"What is 84 * 3 / 2?"},{"text":"Tell me an interesting fact about the universe!"},{"text":"Explain quantum computing in simple terms."}],"safetensors":{"parameters":{"BF16":9653100528,"F32":3840},"total":9653104368,"sharded":true,"totalFileSize":19306390537},"hasBlockedOids":false,"region":"us","isQuantized":false,"licenseFilePath":"LICENSE"}}">

## Evaluation results [](https://huggingface.co/docs/hub/eval-results)

- [llamaindex/ExtractBench](/datasets/llamaindex/ExtractBench) [leaderboard ](/datasets/llamaindex/ExtractBench?eval_result=Qwen/Qwen3.5-9B)
-

Mean [View evaluation results ](/Qwen/Qwen3.5-9B/discussions/67) [
source](https://huggingface.co/datasets/llamaindex/ExtractBench)
Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file
86.1 *

-

Short [View evaluation results ](/Qwen/Qwen3.5-9B/discussions/67) [
source](https://huggingface.co/datasets/llamaindex/ExtractBench)
Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file
92.31 *

-

Medium [View evaluation results ](/Qwen/Qwen3.5-9B/discussions/67) [
source](https://huggingface.co/datasets/llamaindex/ExtractBench)
Pipeline name: qwen3_5_9b_vllm_extract_oneshot_structured_output_file
81.12 *

-
+1 more
- [Idavidrein/gpqa](/datasets/Idavidrein/gpqa) · Diamond [View evaluation results ](/Qwen/Qwen3.5-9B/discussions/2) [leaderboard ](/datasets/Idavidrein/gpqa?eval_result=Qwen/Qwen3.5-9B&leaderboard_task_id=diamond)
81.7

- [Delores-Lin/MDPBench](/datasets/Delores-Lin/MDPBench) [leaderboard ](/datasets/Delores-Lin/MDPBench?eval_result=Qwen/Qwen3.5-9B)
-
+19 more

Expand 6 benchmarks

System theme

Company
[TOS](/terms-of-service) [Privacy](/privacy) [About](/huggingface) [Careers](https://apply.workable.com/huggingface/) [](/) Website
[Models](/models) [Datasets](/datasets) [Spaces](/spaces) [Pricing](/pricing) [Docs](/docs)