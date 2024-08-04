from typing import Optional

from pydantic import BaseModel


class Model(BaseModel):
    # The family of model to download
    name: str
