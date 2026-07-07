# GPU image for the OpenAI Privacy Filter (opf) token-classification model.
# Model weights are mounted as a verified modelwrap (MWP) read-only
# filesystem at boot — no HuggingFace download or egress required.
FROM pytorch/pytorch:2.6.0-cuda12.6-cudnn9-runtime

# gcc is needed at runtime: triton JIT-compiles its CUDA driver and
# per-kernel launchers from C source. triton ships its own cuda.h and
# ptxas, so gcc is the only missing piece.
RUN apt-get update && apt-get install -y --no-install-recommends curl gcc \
    && rm -rf /var/lib/apt/lists/*

# torch is preinstalled in the pytorch/pytorch base image; opf's torch dep
# is already satisfied, so pip skips it.
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Pre-populate tiktoken cache so o200k_base doesn't need network egress.
# The cache file is named by sha1(url) — deterministic, never changes.
COPY tiktoken_cache /app/tiktoken_cache

COPY server.py /app/server.py

WORKDIR /app

ENV OPF_DEVICE=cuda \
    TIKTOKEN_CACHE_DIR=/app/tiktoken_cache

EXPOSE 8001

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8001"]
