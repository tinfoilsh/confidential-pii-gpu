# confidential-pii-gpu

GPU enclave serving the [OpenAI Privacy Filter](https://huggingface.co/openai/privacy-filter) — same model and API as [`confidential-pii-cpu`](https://github.com/tinfoilsh/confidential-pii-cpu), but on a GPU for lower-latency inference.

See the CPU repo for API details and model background. The only differences are the base image (`pytorch/pytorch:2.6.0-cuda12.6-cudnn9-runtime`), `OPF_DEVICE=cuda`, and the nvidia runtime.
