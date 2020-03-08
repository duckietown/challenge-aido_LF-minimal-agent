FROM duckietown/aido-base-python3:daffy-aido4

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
RUN pip list

COPY . .


ENV DISABLE_CONTRACTS=1
ENTRYPOINT ["python3", "minimal_agent.py"]
