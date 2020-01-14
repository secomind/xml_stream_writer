defmodule XMLStreamWriter do
  def new_document() do
    {:ok, "", []}
  end

  def start_document(state) do
    {:ok, ~s(<?xml version="1.0" encoding="UTF-8"?>), state}
  end

  def start_element(state, local_name, attributes) do
    attributes_string = format_attributes(attributes)

    {:ok, [?<, local_name, attributes_string, ?>], [local_name | state]}
  end

  def end_element([local_name | state]) do
    {:ok, ["</", local_name, ?>], state}
  end

  def empty_element(state, local_name, attributes) do
    attributes_string = format_attributes(attributes)

    {:ok, [?<, local_name, attributes_string, "/>"], state}
  end

  def characters(state, text) do
    {:ok, text, state}
  end

  defp format_attributes(attributes) do
    Enum.map(attributes, fn {attribute_name, attribute_value} ->
      [?\s, to_string(attribute_name), ~s(="), attribute_value, ?"]
    end)
  end
end
