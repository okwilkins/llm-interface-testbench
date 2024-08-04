"""Module for removing models using different clients.

Typical usage example:

  import ollama

  client = ollama.Client()
  remover = OllamaModelRemover(client)
  remover.remove('model_name')
"""

from typing import Protocol

import ollama


class ModelRemover(Protocol):
    def remove(self, model: str) -> None:
        """
        Method that removes a model from the file system for the service.

        Args:
            model: The name of the model to be removed.
        """
        ...


class OllamaModelRemover:
    """Remover for models using the Ollama client.

    This class provides a method to remove models using an instance of the Ollama client.
    """

    def __init__(self, client: ollama.Client) -> None:
        """Initialise the remover with an Ollama client.

        Args:
            client: An instance of the Ollama client.
        """
        self._client = client

    def remove(self, model: str) -> None:
        """Remove the specified model using the Ollama client.

        Args:
            model: The name of the model to be removed.
        """
        self._client.delete(model)
