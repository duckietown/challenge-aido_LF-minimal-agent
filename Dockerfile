ARG AIDO_REGISTRY
FROM ${AIDO_REGISTRY}/duckietown/aido-base-python3:daffy-aido4

COPY requirements.* ./
RUN pip install -r requirements.resolved
RUN pip list

COPY . .

RUN PYTHON_PATH=. python3 -c "import minimal_agent"

ENTRYPOINT ["python3", "minimal_agent.py"]
