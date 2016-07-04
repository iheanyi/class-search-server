defmodule Management do
  # Module responsible for data management.
  import Ecto.Query
  alias ClassSearch.Repo
  alias ClassSearch.Term
  alias ClassSearch.Department
  alias ClassSearch.Course
    
  def import_terms do
    terms = Scraper.fetch_terms
    |> Enum.map(fn term -> 
      data = %{name: term.name, tag: term.value}
      changeset = Term.changeset(%Term{}, data)
      old_term = Repo.get(Term, term.value)
      if is_nil old_term do
        case Repo.insert(changeset) do 
          {:ok, _term} ->
            IO.puts "Successfully inserted Term (#{data.tag} - #{data.name})"
          {:error, changeset} ->
            IO.puts "Error inserting Term (#{data.tag} - #{data.name})"
        end
      end
    end
    )
    terms
  end
  
  def import_departments do
    # Import departments from the parser.
    departments = Scraper.fetch_departments
    |> Enum.map(fn dept ->
      name = String.strip(dept.name)
      value = String.strip(dept.value)
      data = %{name: name, tag: value}
      changeset = Department.changeset(%Department{}, data)
      old_dept = Repo.get(Department, dept.value)

      if is_nil old_dept do
        case Repo.insert(changeset) do
          {:ok, _dept} ->
            IO.puts "Successfully inserted #{data.tag} department"
          {:error, changeset} ->
            IO.puts "Error inserting Department #{data.tag} - #{data.name}"
        end
      end
    end)
    departments
  end

  def import_courses do
    # We should probably go through and loop through the instructors, to be
    # honest. Create an Instructor Model and update the name based off of that.
    # Probably will have to do the same for locations as well, to be honest.
    # Also, we probably want to rewrite this so that rather than waiting to
    # fetch every single one before updating the database, we can just do it on
    # a per-record basis. That way, if one fails to update, it won't screw up
    # everything else.
    terms = Repo.all(from(t in Term, select: t.tag))
    departments = Repo.all(from(d in Department, select: d.tag))

    all_courses = Enum.map(terms, fn term -> 
      Enum.map(departments, fn dept -> 
      term_dept_courses = Scraper.fetch_term_dept_html(term, dept) 
      |> Enum.map(fn course ->
        # We want to loop through this and get the relevant info.
        # Get the matching records.
        course_name = course.name
        course_number = course.course_number
        course_dept = dept
        
        course_records = Repo.all(from(c in Course, where: c.name ==
        ^course_name and c.course_number == ^course_number))
        
        #course_record = List.first(course_records)
        # Insert the new entry into the database.
        if (length course_records) === 0 do
          course_data = %{name: course_name, course_number: course_number,
            department_id: course_dept}

          course_changeset = Course.changeset(%Course{}, course_data)
          
          case Repo.insert(course_changeset) do 
            {:ok, course_record} ->
              IO.puts "Successfully inserted #{course_data.course_number} -
              #{course_data.name}."
            {:error, changeset} ->
              IO.puts "Error inserting #{course_data.name} into database.
              #{Enum.join(changeset.errors, ",")}"
          end

        else
          course_record = List.first(course_records)
        end

        
        # Section specific information
        section_number = course.section
          
        # Should probably use regex for AM + PM
        section_timeslots = course.times # ;)
        section_crn = course.crn
        section_open_seats = course.open_seats
        section_max_seats = course.max_seats
        section_begin_dates = course.begin_dates
        section_end_dates = course.end_dates 
        section_instructors = course.instructors
        section_books_url = course.books_link
        section_term = course.term
        section_location = course.locations


        # Add in Instructor Changeset and Migrations.

        # Add in Location Changeset and Migrations.

        # Add in Timeslot Changeset and Migrations.

        section = Repo.get!(section_crn)

        if is_nil section do
          # Get Section Data for insertion.
          section_data = %{}
        end
        end)
      end)
      end)

    #term_dept_courses = Scraper.fetch_all_courses
  end
end
