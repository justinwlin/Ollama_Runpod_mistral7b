# Summary

Referred to these blogs on how to get this running:
https://medium.com/@pooya.haratian/running-ollama-with-runpod-serverless-and-langchain-6657763f400d

https://github.com/hommayushi3/exllama-runpod-serverless

## Limitations
Unable to prebake the model in during build time. Tried to run it on the server / tarball compress the files and use a COPY function, but didn't seem to work. And other issues.
In the end, the best way is probably to deploy this model on a network volume and SYMLINK the .ollama folder to the network volume folder. This way after the first download of the model, it will be cached and subsequent calls will be faster.

But for now, I'm just going to leave it as it is and just let it download the mistral 4b model as it meets my use-cases due to the speed after first download.