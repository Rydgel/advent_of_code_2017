defmodule Day9 do
  @moduledoc """
  --- Day 9: Stream Processing ---
  http://adventofcode.com/2017/day/9
  """

  use Application

  defmodule StreamState do
    defstruct(
      in_garbage: false,
      skip_next: false,
      garbage_count: 0,
      group_nesting: 0,
      group_score: 0
    )
  end

  def process_char(_char, %StreamState{skip_next: true} = state) do
    %StreamState{state | skip_next: false}
  end

  def process_char("!", state) do
    %StreamState{state | skip_next: true}
  end

  def process_char(">", %StreamState{in_garbage: true} = state) do
    %StreamState{state | in_garbage: false}
  end

  def process_char(_char, %StreamState{in_garbage: true} = state) do
    Map.update!(state, :garbage_count, &(&1 + 1))
  end

  def process_char("{", state) do
    Map.update!(state, :group_nesting, &(&1 + 1))
  end

  def process_char("}", state) do
    state
      |> Map.update!(:group_score, &(&1 + state.group_nesting))
      |> Map.update!(:group_nesting, &(&1 - 1))
  end

  def process_char("<", state) do
    %StreamState{state | in_garbage: true}
  end
  
  def process_char(_char, state), do: state

  def day_9_1(input) do
    input
      |> Enum.reduce(%StreamState{}, &process_char/2)
      |> Map.get(:group_score)
  end

  def day_9_2(input) do
    input
      |> Enum.reduce(%StreamState{}, &process_char/2)
      |> Map.get(:garbage_count)
  end

  def start(_type, _args) do
    input = String.codepoints(File.read!("input.txt"))
    IO.inspect day_9_1(input)
    IO.inspect day_9_2(input)
    Supervisor.start_link [], strategy: :one_for_one
  end
end
