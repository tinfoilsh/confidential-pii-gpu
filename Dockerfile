# GPU image for the OpenAI Privacy Filter (opf) token-classification model.
# Uses the PyTorch CUDA base so torch sees the GPU. The model weights are
# NOT baked into the image — they download from HuggingFace on first boot
# and are cached on the hf-cache volume.
FROM pytorch/pytorch:2.6.0-cuda12.6-cudnn9-runtime

RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# torch is already installed by the base image; pip skips it.
RUN pip install --no-cache-dir \
    https://github.com/openai/privacy-filter/archive/refs/heads/main.tar.gz \
    fastapi \
    "uvicorn[standard]"

COPY server.py /app/server.py

WORKDIR /app

ENV HF_HOME=/hf-cache \
    OPF_CHECKPOINT=/hf-cache/privacy-filter \
    OPF_DEVICE=cuda

EXPOSE 8001

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8001"]
