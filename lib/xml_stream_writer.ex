#
# This file is part of xml_stream_writer.
#
# Copyright 2020 Ispirata Srl
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

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
