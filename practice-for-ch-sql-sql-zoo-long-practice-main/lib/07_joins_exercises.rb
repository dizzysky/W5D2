# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery';
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
  SELECT
      title
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Harrison Ford';

  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the starring
  # role. [Note: The ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role.]
  execute(<<-SQL)
  SELECT
  title
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    actors.name = 'Harrison Ford'
    AND ord <> 1;

  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
  SELECT
  title,
  name
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    yr = 1962
    AND ord = 1;
 
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
  SELECT
  yr,
  COUNT(title)
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    name = 'John Travolta'
  GROUP BY
    yr
  HAVING
    COUNT(title) >= 2
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
  with her_movies as (SELECT
    title,
    name
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    name = 'Julie Andrews')

    SELECT
  movies.title,
  actors.name
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  join 
    her_movies on her_movies.title = movies.title
  WHERE
  ord = 1;
  
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.


  execute(<<-SQL)
  select 
  role_numbers.name 
  from (SELECT
  count(name) as number_of_roles, 
  name
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id 
  WHERE
    ord = 1
  group by 
    name) as role_numbers
  where role_numbers.number_of_roles >= 15   
  order by role_numbers.name 
    SQL

end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
  select 
  film_casts.title,
  number_actors 
  from 
  (select count(name) as number_actors, 
  title 
  from 
  actors 
  join castings on actors.id = castings.actor_id
  join movies on castings.movie_id = movies.id
  where yr = 1978 
  group by title) as film_casts 
  order by film_casts.number_actors desc, title asc 

  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
with art_movies as (
  SELECT
  title
FROM
  movies
JOIN
  castings ON movies.id = castings.movie_id
JOIN
  actors ON castings.actor_id = actors.id
WHERE
  actors.name = 'Art Garfunkel')

  select distinct(name)
  from 
  actors 
  join castings on actors.id = castings.actor_id
  join movies on castings.movie_id = movies.id
  join art_movies on art_movies.title = movies.title 
  where name <> 'Art Garfunkel'

  SQL
end