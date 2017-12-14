defmodule Day7 do
  @moduledoc """
  --- Day 7: Recursive Circus ---
  https://adventofcode.com/2017/day/7
  """
  use Application

  defmodule Node, do: defstruct name: nil, weight: 0, sub_towers: []

  def parse_node(line) do
    [name, weight_rp | relation] = line |> String.split(" ")
    {weight, _} = String.replace(weight_rp, ~r/\(|\)/, "") |> Integer.parse
    subtowers = relation
      |> List.delete_at(0)
      |> Enum.map(&String.replace(&1, ~r/\s|,/, ""))
    %Node{name: name, weight: weight, sub_towers: subtowers}
  end

  def parse_nodes(input) do
    input
      |> String.split("\n")
      |> Enum.map(&parse_node/1)
  end

  def bottom_node(nodes) do
    holders = nodes 
      |> Enum.filter(&(length(&1.sub_towers) > 0))
      |> Enum.map(&(&1.name))
    subtowers = nodes
      |> Enum.reduce([], fn(node, acc) -> [node.sub_towers | acc] end)
      |> List.flatten
    [bottom_node | _] = holders -- subtowers
    bottom_node
  end

  def day7_1(nodes), do: bottom_node(nodes)

  def tower_weight(programs_by_name, node) do
    subs_weight = node.sub_towers
      |> Enum.map(&(tower_weight(programs_by_name, programs_by_name[&1])))
      |> Enum.sum
    node.weight + subs_weight
  end

  def find_imbalanced_node(programs_by_name, node, delta) do
    subtowers = node.sub_towers |> Enum.map(&(programs_by_name[&1]))
    subtowers_weights = subtowers |> Enum.map(&(tower_weight(programs_by_name, &1)))
    unique_weights = subtowers_weights |> Enum.uniq

    case length(unique_weights) do
      1 ->
        {:done, node, delta}
      _ ->
        odd_weight = unique_weights
          |> Enum.filter(&(Enum.count(subtowers_weights, fn(x) -> x == &1 end) == 1))
          |> List.first
        expected_weight = unique_weights
          |> Enum.filter(&(&1 != odd_weight))
          |> List.first
        imbalanced_subtower = Enum.zip(subtowers, subtowers_weights)
          |> Enum.filter(fn({_, weight}) -> weight == odd_weight end)
          |> Enum.map(fn({subtower,_}) -> subtower end)
          |> List.first
        delta = expected_weight - odd_weight
        find_imbalanced_node(programs_by_name, imbalanced_subtower, delta)
    end
  end

  def day7_2(nodes) do
    programs_by_name =
      for node <- nodes,
      into: Map.new, 
      do: {node.name, node}

    bottom = programs_by_name[bottom_node(nodes)]
    {:done, node, weight_delta} = find_imbalanced_node(programs_by_name, bottom, 0)
    node.weight + weight_delta
  end

  def start(_type, _args) do
    nodes = File.read!("input.txt") |> parse_nodes
    IO.inspect day7_1(nodes)
    IO.inspect day7_2(nodes)
    Supervisor.start_link [], strategy: :one_for_one
  end
end
