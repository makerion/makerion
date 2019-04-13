defmodule Makerion.PrintTest do
  use Makerion.DataCase

  alias Makerion.Print

  describe "print_files" do
    alias Makerion.Print.PrintFile

    @valid_attrs %{name: "print_fixture", path: "print_fixture.gcode", tempfile: Path.join([File.cwd!, "test", "fixtures", "print_fixture.gcode"])}
    @invalid_attrs %{name: nil, path: nil, tempfile: nil}

    def print_file_fixture(attrs \\ %{}) do
      {:ok, print_file} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Print.create_print_file()

      print_file
    end

    test "list_print_files/0 returns all print_files" do
      print_file = print_file_fixture()
      assert Print.list_print_files() == [print_file]
    end

    test "get_print_file!/1 returns the print_file with given id" do
      print_file = print_file_fixture()
      assert Print.get_print_file!(print_file.id) == print_file
    end

    test "create_print_file/1 with valid data creates a print_file" do
      assert {:ok, %PrintFile{} = print_file} = Print.create_print_file(@valid_attrs)
      assert print_file.name == "print_fixture"
      assert print_file.path == "print_fixture.gcode"
    end

    test "create_print_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Print.create_print_file(@invalid_attrs)
    end

    test "delete_print_file/1 deletes the print_file" do
      print_file = print_file_fixture()
      assert {:ok, %PrintFile{}} = Print.delete_print_file(print_file)
      assert_raise Ecto.NoResultsError, fn -> Print.get_print_file!(print_file.id) end
    end
  end
end
