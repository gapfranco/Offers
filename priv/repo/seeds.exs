# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Offers.Repo.insert!(%Offers.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias DatabaseSeeder
alias Offers.Repo
alias Offers.Teach

# Verifica se já tem conteudo
ctg =
  Teach.list_bids()
  |> Enum.count()

# Processa apenas se não tiver conteudo
json =
  if ctg == 0 do
    with {:ok, saida} <- DatabaseSeeder.load_data("priv/repo/db.json"), do: saida
  else
    []
  end

for reg <- json do
  university =
    Teach.get_university_by_name(reg["university"]["name"]) ||
      Repo.insert!(%Teach.University{
        name: reg["university"]["name"],
        score: reg["university"]["score"],
        logo_url: reg["university"]["logo_url"]
      })

  campus =
    Teach.get_campus_by_name(reg["campus"]["name"]) ||
      Repo.insert!(%Teach.Campus{
        name: reg["campus"]["name"],
        city: reg["campus"]["city"],
        university_id: university.id
      })

  course =
    Teach.get_course_by_name(reg["course"]["name"]) ||
      Repo.insert!(%Teach.Course{
        name: reg["course"]["name"],
        kind: reg["course"]["kind"],
        level: reg["course"]["level"],
        shift: reg["course"]["shift"],
        university_id: university.id,
        campus_id: campus.id
      })

  Repo.insert!(%Teach.Bid{
    full_price: reg["full_price"],
    price_with_discount: reg["price_with_discount"],
    discount_percentage: reg["discount_percentage"],
    start_date: reg["start_date"],
    enrollment_semester: reg["enrollment_semester"],
    enabled: reg["enabled"],
    course_id: course.id,
    university_id: university.id,
    campus_id: campus.id
  })
end
