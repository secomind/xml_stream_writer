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
    escaped_text =
      if needs_escaping?(text) do
        escape(text)
      else
        text
      end

    {:ok, escaped_text, state}
  end

  defp needs_escaping?(text),
    do: String.match?(text, ~r/[<>&]/)

  defp escape(text),
    do: escape(text, "")

  defp escape("", acc),
    do: acc

  defp escape(<<?<, rest::binary>>, acc),
    do: escape(rest, <<acc::binary, "&lt;">>)

  defp escape(<<?>, rest::binary>>, acc),
    do: escape(rest, <<acc::binary, "&gt;">>)

  defp escape(<<?&, rest::binary>>, acc),
    do: escape(rest, <<acc::binary, "&amp;">>)

  defp escape(<<c, rest::binary>>, acc),
    do: escape(rest, <<acc::binary, c>>)

  defp format_attributes(attributes) do
    Enum.map(attributes, fn {attribute_name, attribute_value} ->
      case quote_style(attribute_value) do
        :use_quot ->
          [?\s, to_string(attribute_name), ~s(="), attribute_value, ?"]

        :use_apos ->
          [?\s, to_string(attribute_name), ~s(='), attribute_value, ?']

        :escape_and_quot ->
          [?\s, to_string(attribute_name), ~s(="), escape(attribute_value), ?"]

        :escape_and_apos ->
          [?\s, to_string(attribute_name), ~s(='), escape(attribute_value), ?']

        :escape_everything ->
          [?\s, to_string(attribute_name), ~s(="), escape_everything(attribute_value), ?"]
      end
    end)
  end

  defp quote_style(text) do
    if String.match?(text, ~r/[<>&'"]/) do
      has_quot = String.contains?(text, ~s("))
      has_apos = String.contains?(text, ~s('))
      needs_escape = String.match?(text, ~r/[<>&]/)

      cond do
        not needs_escape and has_quot and not has_apos -> :use_apos
        not needs_escape and not has_quot and has_apos -> :use_quot
        not has_quot -> :escape_and_quot
        not has_apos -> :escape_and_apos
        true -> :escape_everything
      end
    else
      :use_quot
    end
  end

  defp escape_everything(text),
    do: escape_everything(text, "")

  defp escape_everything("", acc),
    do: acc

  defp escape_everything(<<?", rest::binary>>, acc),
    do: escape_everything(rest, <<acc::binary, "&quot;">>)

  defp escape_everything(<<?', rest::binary>>, acc),
    do: escape_everything(rest, <<acc::binary, "&apos;">>)

  defp escape_everything(<<?<, rest::binary>>, acc),
    do: escape_everything(rest, <<acc::binary, "&lt;">>)

  defp escape_everything(<<?>, rest::binary>>, acc),
    do: escape_everything(rest, <<acc::binary, "&gt;">>)

  defp escape_everything(<<?&, rest::binary>>, acc),
    do: escape_everything(rest, <<acc::binary, "&amp;">>)

  defp escape_everything(<<c, rest::binary>>, acc),
    do: escape_everything(rest, <<acc::binary, c>>)
end
