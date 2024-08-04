import os
import subprocess
import re

from fastapi import FastAPI, HTTPException, status

from llmit.servers.types import Model

app = FastAPI()


@app.post(
    "/download",
    status_code=status.HTTP_204_NO_CONTENT,
    responses={
        500: {
            "description": "Internal Server Error",
            "content": {
                "application/json": {
                    "example": {"detail": "Model download failed: <error_message>"}
                }
            },
        }
    },
)
async def download(model: Model) -> None:
    try:
        subprocess.run(
            ["ollama", "pull", model.name],
            check=True,
            capture_output=True,
            text=True,
        )
    except subprocess.CalledProcessError as e:
        error = re.findall(r"pull model manifest: (.+)\n", e.stderr)

        if len(error) >= 1:
            error = error[0]
        else:
            error = ""

        raise HTTPException(status_code=500, detail=f"Model download failed: {error}")


@app.post("/load")
async def load(model: Model):
    os.system(f"ollama run {model.name}")
