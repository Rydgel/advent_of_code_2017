defmodule Day8 do
  @moduledoc """
  --- Day 8: I Heard You Like Registers ---
  https://adventofcode.com/2017/day/8
  """

  use Application

  defmodule Instruction, do: defstruct register: nil, mutation: nil, condition: nil
  defmodule Condition, do: defstruct register: nil, comparison: nil, value: nil

  defp mut_ops do
    %{
      "dec" => fn a -> fn b -> b - a end end,
      "inc" => fn a -> fn b -> b + a end end,
    }
  end

  defp comp_ops do
    %{
      "<" => fn a, b -> a < b end,
      ">" => fn a, b -> a > b end,
      "<=" => fn a, b -> a <= b end,
      ">=" => fn a, b -> a >= b end,
      "==" => fn a, b -> a == b end,
      "!=" => fn a, b -> a != b end,
    }
  end

  def parse_instruction(line) do
    [mut_reg, mut_op_str, mut_value_s, _, comp_reg, comp_op_str, comp_value_s] = String.split line, " "
    {mut_value, _} = Integer.parse(mut_value_s)
    {comp_value, _} = Integer.parse(comp_value_s)
    comp_op = comp_ops()[comp_op_str]
    condition = %Condition{register: comp_reg, comparison: comp_op, value: comp_value}
    mut_op = mut_ops()[mut_op_str].(mut_value)
    %Instruction{register: mut_reg, mutation: mut_op, condition: condition}
  end

  def apply_instruction(%Instruction{register: r, mutation: m, condition: c}, registers) do
    %Condition{register: test_register, comparison: compare, value: test_value} = c
    value_from_register = registers |> Map.get(test_register, 0)
    if compare.(value_from_register, test_value) do
      current_value = registers |> Map.get(r, 0)
      new_value = m.(current_value)
      registers |> Map.put r, new_value
    else registers end
  end

  def day8_1(instructions) do
    instructions
      |> Enum.reduce(%{}, &apply_instruction/2)
      |> Map.values
      |> Enum.max
  end

  def day8_2(instructions) do
    instructions
      |> Enum.scan(%{}, &apply_instruction/2)
      |> Enum.map(&(Map.values(&1) |> Enum.max(fn -> 0 end)))
      |> Enum.max
  end

  def start(_type, _args) do
    instructions = File.read!("input.txt")
      |> String.split("\n")
      |> Enum.map(&parse_instruction/1)
    
    IO.inspect day8_1(instructions)
    IO.inspect day8_2(instructions)

    Supervisor.start_link [], strategy: :one_for_one
  end
end
