defmodule DomainChampion do
  def hello do
    repo = Git.new("../../../Dott/functions")

    results =
      repo
      |> files()
      |> Enum.map(fn file ->
        if Regex.match?(~r/src/, file) do
          {:ok, output} = Git.blame(repo, ~w(#{file} --porcelain))

          authors =
            Regex.scan(~r/\nauthor (.*)\n/, output, capture: :all)
            |> Enum.map(fn match ->
              List.last(match)
            end)
            |> Enum.uniq

          [file, Enum.join(authors, ";")]
        else
          []
        end
      end)

    file = File.open!("test.csv", [:write, :utf8])
    results
    |> IO.inspect
    |> CSV.encode
    |> Enum.each(&IO.write(file, &1))
  end

  def files(repo) do
    {:ok, output} = Git.ls_tree(repo, ~w(-r master))

    output
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.split(&1, "\t", trim: true)))
    |> Enum.map(&(List.last(&1)))
    |> IO.inspect
  end
end
