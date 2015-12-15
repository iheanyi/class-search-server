defmodule Scraper do
  alias Scraper.Utils, as: Utils
  @base_url "https://class-search.nd.edu/reg/srch/ClassSearchServlet"
  @base_desc_url "https://class-search.nd.edu/reg/srch/ClassSearchServlet"

  @doc """
  Initialize the initial page and everything.
  """
  def initialize(page \\ :initial) do
    Scraper.Search.start_link(page)
  end
  
  @doc """
  Fetches the initial Class Search page.
  """
  def fetch_initial_page do
    # We just want to get the initial URL
    html = HTTPoison.get!(@base_url).body
    
    html
  end

 
  @doc """
  Fetches a list of all the terms, it's lit. 
  """
  def fetch_terms do
    html = fetch_initial_page #Scraper.Search.get(:initial)
    terms = Floki.find(html, "select[name=TERM] option")
    |> Enum.map(fn term -> 
        term_value = Floki.attribute(term, "value")
        |> List.first
        term_name = String.strip(Floki.text(term))
      
        # Let's return a JSON mapping of all of the terms.
        %{name: term_name, value: term_value}
      end
    ) 

    terms
  end

  @doc """
  Fetches a list of all of the departments.
  """
  def fetch_departments do 
    html = fetch_initial_page
    departments = Floki.find(html, "select[name=SUBJ] option")
    |> Enum.map(fn dept ->
      dept_value = Floki.attribute(dept, "value")
      |> List.first
      dept_name = Floki.text(dept)

      # Let's return a JSON mapping of all the departments and their values.
      %{name: dept_name, value: dept_value}
    end
    )
  end

  @doc """
  Processes the HTML for a course row.
  """
  def process_section_html(first_section, term, dept) do
      # Each Cell/Index
      # (0) Course Section and Course Number, also has URL link to the books
      # relevant to that section in Hammes Bookstore.
      # (1) Title of the course.
      # (2) Number of credits for the course.
      # (3) Status of the course seats (OP for open, CL for closed).
      # (4) Max number of seats.
      # (5) Open number of seats.
      # (6) Cross-Listed?
      # (7) CRN for the course. 
      # (8) Syllabus for the course
      # (9) Instructor for the course!
      # (10) When the course meets, course start time.
      # * Note, these may be prone to having more than one start time, so we
      # have to think of how to show / reflect this in the user interface for
      # various sub-sections. Design flaw on ND's part. -_- 
      # (11) Begin/Start date for the course.
      # (12) End date for the course.
      # (13) Course Location.
      # Also, probably should insert an actual link/reference to the actual
      # course description page...JUST IN CASE, feel me?
      {_, _, first_cell} = List.first(first_section)
      {_, _, course_num_section_text} = List.first(first_cell)
      # The books link will always be the last element.
      {_, course_books_link_tag, _} = List.last(first_cell)
     
      # Prints out the course number and the section number. O_O
      course_num_section = List.first(course_num_section_text)
      {_, course_books_link} = List.first(course_books_link_tag)
      [course_num, course_section] = String.split(course_num_section," - ", trim: true)
 
      # Second Cell - Course Title
      {_, _, second_cell} = Enum.at(first_section, 1)
      # This converts the binary of the char list back to the binary of the
      # string. Somewhere in a library, the String is getting improperly encoded
      # to a char_list, which is messing up UTf-8. This fixes it.
      course_title = List.first(second_cell) |> :binary.bin_to_list |> to_string
      
            
      # Third Cell - Credits
      {_, _, third_cell} = Enum.at(first_section, 2)
      credits = List.first(third_cell) 

      # Fourth Cell - Status
      {_, _, fourth_cell} = Enum.at(first_section, 3)
      status = List.first(fourth_cell)

      # Fifth Cell - Max Seats
      {_, _, fifth_cell} = Enum.at(first_section, 4)
      max_seats = List.first(fifth_cell)

      # Sixth Cell - Open Seats
      {_, _, sixth_cell} = Enum.at(first_section, 5)
      open_seats = List.first(sixth_cell)

      # Seventh Cell - Cross Listed
      {_, _, seventh_cell} = Enum.at(first_section, 6)
      crosslisted = List.first(seventh_cell)

      # Eighth Cell - CRN
      {_, _, eighth_cell} = Enum.at(first_section, 7)
      course_reg_number = String.strip(List.first(eighth_cell))

      # Ninth Cell - Syllabus
      {_, _, ninth_cell} = Enum.at(first_section, 8)
      syllabus = List.first(ninth_cell)

      # Tenth Cell - Instructor
      # May be more than one of these, would be wise to split these on the
      # instances of the anchor tags in this element, for real.
      {_, _, tenth_cell} = Enum.at(first_section, 9)
      
      # Define instructors as an array
      instructors = Enum.map(tenth_cell, fn tag ->
        # If it is a tuple tag, then we are dealing with valid instructors and
        # not TBA instructors.
        if (is_tuple tag) do   
          # We know we have links in this.
          # We want to capture the instructor id
          # So we don't have namespacing issues.
          {_, hrefs, _} = tag
          {_, href} = List.first(hrefs) # Grab first HREF
          instructor_id_map = Regex.named_captures(~r/P\=(?<id>\d+)/, href)
          instructor_id = instructor_id_map["id"]
          
          # Additionally, we want to capture the instructor's names.
          instructor_full_name = Floki.text(tag)
          {html_tag, html_attributes, html_text} = tag
          # See note for Course Title
          instructor_name_text = List.first(html_text) |> :binary.bin_to_list |> to_string
          IO.puts instructor_name_text
          instructor_name_array = instructor_name_text 
          |> String.strip 
          |> String.split(", ", trim: true) #String.split(instructor_name_text, ", ", trim: true)
          [instructor_last, instructor_first] = instructor_name_array
          instructor = "#{instructor_first} #{instructor_last}"
        else 
          # The instructor will probably be TBA -_-
          instructor = "TBA"
        end
        instructor
      end)
      
      # If name_length >= 2, we have a valid instructor
      # In order to further refine the instructor,
      # We can access the `href` of the <a> tag
      # and use regex to match `P=<id>'`.
      # Storing this in the database will allow us to know exactly
      # which specific instructor we are looking at. So therefore,
      # Instructors with mad common names like
      # Mike Johnson will not be duplicated in the array.
      
      # Eleventh Cell - Timeslots
      # *Note: May have more than one timeslot with the (1).
      # This will probably be reflected as a one-to-many Section to Timeslots
      # in Phoenix.
      # Additionally, gotta split on the timeslots by their start time, end
      # times, and days of the week.
      # Gotta parse this and make the timeslots for real, for reals. u_u 
      {_, _, eleventh_cell} = Enum.at(first_section, 10)
      times = Utils.filter_binary_and_strip(eleventh_cell) #filtered_times

      timeslots = String.strip(List.first(eleventh_cell))

      # Tweltfhh Cell - Begin Date
      # *Note: May have more than one begin date if they have more than one
      # timeslot. :/ Gotta do that some magic here. Luckily, shouldn't be as
      # difficult.
      {_, _, twelfth_cell} = Enum.at(first_section, 11)
      begin_dates = twelfth_cell
      |> Utils.filter_binary_and_strip
      
      begin_date = String.strip(List.first(twelfth_cell))

      # Thirteenth Cell - End Date
      # *Note: May have more than one end date, ala Timeslots.
      {_, _, thirteenth_cell} = Enum.at(first_section, 12)
      end_dates = thirteenth_cell
      |> Utils.filter_binary_and_strip
      
      end_date = String.strip(List.first(thirteenth_cell))


      # Fourteenth Cell - Where
      # * Note - May have more than one location, break on splits fam. 
      {_, _, fourteenth_cell} = Enum.at(first_section, 13)
      locations = fourteenth_cell
      |> Utils.filter_binary_and_strip
      
      location = String.strip(List.first(fourteenth_cell))
      IO.puts "#{course_num} - #{course_section} - #{course_title}"
      IO.puts "CRN #{course_reg_number}"
      IO.puts "Timeslots: #{timeslots}"
      IO.puts "Times: #{Enum.join(times, ", ")}"
      IO.puts "Instructor(s): #{Enum.join(instructors, ", ")}"
      IO.puts "#{credits} credits, #{open_seats}/#{max_seats} seats left"
      IO.puts "Starts #{begin_date} and Ends #{end_date}"
      IO.puts "Location: #{location}"
      IO.puts "Books Link: #{course_books_link}"
      course_section_obj = %{
        name: course_title,
        section: course_section,
        course_number: course_num,
        timeslots: timeslots,
        times: "#{Enum.join(times, ", ")}",
        crn: course_reg_number,
        term: term,
        credits: credits,
        open_seats: open_seats,
        max_seats: max_seats,
        begin_date: begin_date,
        end_date: end_date,
        location: location,
        books_link: course_books_link,
        instructors: instructors
      }
  end

  @doc """
  Fetches the HTML for the designated term and dept
  """
  def fetch_term_dept_html(term, dept) do
      content_type = %{"Content-type" =>
        "application/x-www-form-urlencoded;charset=utf-8"}
      html =
      HTTPoison.post!(@base_url,
      {:form , [
          "TERM": term,
          "DIVS": "A",
          "CAMPUS": "M",
          "SUBJ": dept,
          "ATTR": "0ANY",
          "CREDIT": "A",
        ]},
        content_type
      ).body
      
      course_sections = Floki.find(html, "#resulttable tbody tr")

      course_sections
      |> Enum.map(fn {_, _, section} -> 
        process_section_html(section, term, dept)
      end
      )

  end

  @doc """
  Fetches the attributes for every single course.
  """
  def fetch_attributes do 
    html = fetch_initial_page
    
    attributes = Floki.find(html, "select[name=ATTR] option")
    |> Enum.map(fn attr -> 
        attr_value = Floki.attribute(attr, "value")
        |> List.first
        attr_name = String.strip(Floki.text(attr))
      
        # Let's return a JSON mapping of all of the terms.
        %{name: attr_name, value: attr_value}
      end
    ) 
  end

  @doc """
  Fetches the courses for every single term and department.
  """
  def fetch_all_courses do 
    terms = fetch_terms
    |> Enum.slice(0..1)
    depts = fetch_departments
    
    all_courses = Enum.map(terms, fn term -> 
      IO.puts term.value
      #Task.start_link fn ->
        courses = Enum.map(depts, fn dept -> 
          dept_courses = fetch_term_dept_html(term.value, dept.value)
          %{
            dept: %{
              name: dept.name,
              value: dept.value,
            },
            courses: dept_courses,
          }
        end)
        #end
        %{
          term: %{
            name: term.name,
            value: term.value,
          },
          dept_courses: courses,
        }
    end)
  end

  @doc """
  Processees the HTML for the Course Description.
  """
  def process_course_description_html(html) do 
    {_, _, course_description_table} = Floki.find(html, ".datadisplaytable")
    |> List.first

    [_, description_row] = course_description_table 
    {_, _, description_children} = description_row

    description_nodes = description_children
    |> List.first
    |> Tuple.to_list
    |> List.last
    |> Enum.filter_map(fn item -> is_binary item end, fn item ->
      String.strip(item)
    end)

    course_description = List.first(description_nodes)
    course_description
  end

  @doc """
  Fetch the HTML for the Course Description page.
  """
  def fetch_course_description(term, crn) do
    # Append the CRN and Term to the base_desc_url
    full_url = "#{@base_desc_url}?CRN=#{crn}&TERM=#{term}"
    
    # Fetch course description HTML here and parse it.
    html = HTTPoison.get!(full_url).body
    process_course_description_html(html)
  end

  @doc """
  Fetches the HTML for the first term and department
  """
  def fetch_first() do 
    terms = fetch_terms
    depts = fetch_departments

    first_term = List.first(terms)
    first_dept = List.first(depts)

    first_term_value = "201520" #first_term['value']
    first_dept_value = "AL" # first_dept['value']

    IO.puts "Fetching Term Department stuff"
    IO.puts(first_term_value)
    output = fetch_term_dept_html(first_term_value, first_dept_value)
    first_item = List.first(output)
    fetch_course_description(first_item.term, first_item.crn)
  end
end
