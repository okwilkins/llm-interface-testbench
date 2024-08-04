"""Module for downloading models using different clients.

Typical usage example:

  import ollama

  client = ollama.Client()
  downloader = OllamaModelDownloader(client)
  downloader.download('model_name')
"""

from typing import Protocol

import ollama


class ModelDownloader(Protocol):
    """Protocol for model downloading.

    Classes implementing this protocol should provide a method to download a model.
    """

    def download(self, model: str) -> None:
        """Download the specified model.

        Args:
            model: The name of the model to be downloaded.
        """

    ...


class OllamaModelDownloader:
    """Downloader for models using the Ollama client.

    This class provides a method to download models using an instance of the Ollama client.
    """

    def __init__(self, client: ollama.Client) -> None:
        """Initialise the downloader with an Ollama client.

        Args:
            client: An instance of the Ollama client.
        """
        self._client = client

    def download(self, model: str) -> None:
        """Download the specified model using the Ollama client.

        Args:
            model: The name of the model to be downloaded.
        """
        self._client.pull(model)
