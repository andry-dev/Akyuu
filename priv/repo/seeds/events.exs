alias Akyuu.Repo
alias Akyuu.Music

Music.create_event(:comiket,
  edition: 96,
  start_date: ~D[2019-08-09],
  end_date: ~D[2019-08-12]
)

Music.create_event(:comiket,
  edition: 97,
  start_date: ~D[2019-12-28],
  end_date: ~D[2019-12-31]
)

Music.create_event(:comiket,
  edition: 98,
  start_date: ~D[2020-05-05]
)

Music.create_event(:reitaisai,
  edition: 16,
  start_date: ~D[2019-05-05]
)
