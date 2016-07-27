require 'pry'
# Below adds a method to the String class which can show if a string
# character is an integer
class String
    def is_i?
       /\A[-+]?\d+\z/ === self
    end
end


# Below method loops through the text_files directory
# and adds each file name into the file_array
def run_through_directory
@file_array = []
  Dir.foreach('text_files') do |item|
    next if item == '.' or item == '..'
    @file_array << item
  end
end


def file_array
  @file_array
end


# Below method iterates through each file and parses each line 
# into its own array and pushes it into a parent array
def file_array_parser
  @array_of_parse_files = []
  file_array.each do |file|
    File.open("text_files/#{file}").readlines.each do |line|
      if line.include?("\n") # removes '\n' (line breaker)
        @array_of_parse_files << [line.gsub!(/\n/, '')]
        else
        @array_of_parse_files << [line]
      end      
    end
    @array_of_parse_files 
  end

end


def array_of_parse_files
  @array_of_parse_files
end


# Below method removes middle initial for space_names 
# and pipe_names AND puts comma_names into nested arrays
def remove_initial_and_format_change 
  @reformated_array = []
  array_of_parse_files.each do |info|
    if !info[0].include?("|") && !info[0].include?(",")
      info.map! {|element| element.split(" ")}
      info.each {|element| element.slice!(-4)}  
      @reformated_array << info
    elsif info[0].include?("|")
      info.map! {|element| element.split(" | ")}
      info.each {|element| element.slice!(-4)}  
      @reformated_array << info
    else
      @reformated_array << info
    end
  end
end


def reformated_array
  @reformated_array
end


# Adjusts format of nested arrays so their indexes can be used
def fixed_array
  reformated_array.map! do |element|
    element.join(", ").split(", ")
  end 
end

# Uses is_i? to see if the last char is an integer / meaning the date
# and if so, will reorder the nested arrays to the correct format
def reorder_info
  fixed_array.map! do |element|
    if element[-1][-1].is_i? == true
      order = [0, 1, 2, 4, 3]
      order.map {|x| element[x]}
    else
      element
    end
  end
end


# Below method does two formatting fixes:
# Formats  'F' and 'M' into 'Female' and 'Male'
# Formats dates separated with '-' to use '/' 
def gender_and_date_formater
  reorder_info.each do |element| 
    if element[2] == "M"
      element[2] = "Male"
    elsif element[2] == "F"
      element[2] = "Female"
    end
    if element[3].include?("-")
      element[3].gsub!(/-/, '/')
    end
  end
end


# Below method converts format information into a hash for easier sorting
def array_to_hash
  @final_array = []
  gender_and_date_formater.map do |element|
    final_array << {last_name: element[0], first_name: element[1], gender: element[2], birth_date: element[3], fav_color: element[4]}
  end
  @final_array
end


def final_array
  @final_array
end


# Adds line space '\n' to each array
def add_line_breaks(arr)
  arr.each do |element|
    element[-1] += "\n"
  end
end


# Below method sorts by gender (females before males) then by last name ascending
def sort_by_gender_then_last_name 
  sorted = final_array.sort_by {|k,v| [k[:gender], k[:last_name]] }
  hash_values = sorted.map {|element| element.values}
  with_line_breaks = add_line_breaks(hash_values)
  with_line_breaks.unshift("Output 1:\n")
  with_line_breaks.join(", ").gsub(/,/, '').gsub( /\n\s+/, "\n" )
end


# Below method sorts by birth date, ascending then by last name ascending
def sort_by_birthday_then_last_name
  sorted = final_array.sort_by {|k,v| [k[:birth_date][-2..-1], k[:last_name]] }
  hash_values = sorted.map {|element| element.values}
  with_line_breaks = add_line_breaks(hash_values)
  with_line_breaks.unshift("Output 2:\n")
  with_line_breaks.join(", ").gsub(/,/, '').gsub( /\n\s+/, "\n" )
end


# Below method sorts by last name, descending
def sort_by_last_name
  sorted = final_array.sort_by {|k,v| k[:last_name] }
  hash_values = sorted.map {|element| element.values}.reverse
  with_line_breaks = add_line_breaks(hash_values)
  with_line_breaks.unshift("Output 3:\n")
  with_line_breaks.join(", ").gsub(/,/, '').gsub( /\n\s+/, "\n" )
end


# Below method combines all names
def final_name_info
  sort_by_gender_then_last_name + "\n" +  sort_by_birthday_then_last_name+ "\n" + sort_by_last_name
end


# Below method counts total number of files in the Goal folder
# and uses the number in the create_goal_file 
def file_counter
  Dir.glob(File.join("Goal/", '**', '*')).select { |file| File.file?(file) }.count + 1
end


# Below method creates a new text file with the information from the final_name_info method 
def create_goal_file
  File.open("Goal/goal#{file_counter}.txt", 'w') { |file| file.write("#{final_name_info}") }
end

# Below method will run the necessary methods when the app is called 
def run_it
  run_through_directory
  file_array_parser
  remove_initial_and_format_change
  array_to_hash
  final_name_info
  create_goal_file
end


run_it # runs the method
puts "Please find the consolidated text file named -- goal#{file_counter - 1} -- within the 'Goal' folder in the 'cyrus_challenge' directory that has the parsed information."

