#required
require "yaml"
require "tty-prompt"
require "pastel"
require "tty-spinner"

#tty inits
prompt = TTY::Prompt.new(symbols: {marker: "♦"})
pastel = Pastel.new

#ascii "The Sims" title
def ascii_title
  File.readlines("../docs/ascii_title.txt") do |line|
    puts line
  end
end

#saving created sims to the database file
def save_created_sim(name, gender, life_stage, trait)
    sim_id = {:id => {:name => name, :gender => gender, :life_stage => life_stage, :trait => trait}}
    File.open("../data/database.yml", "a+") { |file| file.write(sim_id.to_yaml) }
    puts "Hooray, you've successfully created #{name}!"
end

#selecting from saved sims
def read_sim_library
log = File.read("../data/database.yml")
saved_sims_options = []
YAML::load_stream(log) do |doc| 
saved_sims_options << "#{doc[:id][:name]}"
end
return saved_sims_options
end

#finding the sim's trait for probability calculations
def find_trait(sim)
#open yaml file, look for the ID that matches the sim's name (which has been passed in), and look for the trait associated with that ID
    log = File.read("../data/database.yml")
    YAML::load_stream(log) do |doc| 
        if sim == doc[:id][:name]
        selected_sim_trait = doc[:id][:trait]
    else
        next 
    end
    return selected_sim_trait
    end
end

def probability_generator(array)
    #code
end

#variables for the menu
home_menu_options = ["Create a Sim!", "Choose a Sim to play", "Read the instructions", "Exit"]
gender_options = ["female", "male"]
life_stage_options = ["baby", "child", "adult", "elder"]
trait_options = ["friendly", "mean"]
interaction_options = ["Become friends", "Become enemies"]

#probabilities
friendly_probability = [[00000], [00011]]  #friendly sim choosing to become friends will be 100% successful, friendly sim trying to become enemies will be 60% successful
mean_probability = [[00011], [00000]]  #mean sim choosing to become friends will be 60% successful, mean sim trying to become enemies will be 100% successful

#menu
puts ascii_title
puts "Welcome to The Sims: Command Line Edition!"
sleep(0.5)
user_selection = 0
until user_selection == home_menu_options[-1]
user_selection = prompt.select("What would you like to do?", home_menu_options)
case user_selection
when home_menu_options[0]
    sleep(0.5)
    input_gender = prompt.select("Choose your Sim's gender:", gender_options)
    if input_gender == "female"
        sleep(0.5)
        input_life_stage = prompt.select("What's her life stage?", life_stage_options)
    elsif input_gender == "male"
        sleep(0.5)
        input_life_stage = prompt.select("What's his life stage?", life_stage_options)
    end
    sleep(0.5)
    if input_gender == "female"
        sleep(0.5)
        input_trait = prompt.select("What kind of Sim will she be?", trait_options)
    elsif input_gender == "male"
        sleep(0.5)
        input_trait = prompt.select("What kind of Sim will he be?", trait_options)
    end
    sleep(0.5)
    puts "Finally, give your Sim a first name:"
    input_name = gets.strip.capitalize
    #make a way to not double up on names
    save_created_sim(input_name, input_gender, input_life_stage, input_trait)
when home_menu_options[1]
    sim_library = YAML.load(File.read("../data/database.yml"))
    if sim_library == false
        puts pastel.bright_yellow("Oops! You haven't created any Sims yet. Please make a different selection.")
    else
    selected_sim = prompt.select("Please select a Sim", read_sim_library)
    end
    updated_sim_selections = read_sim_library
    updated_sim_selections.each_with_index do |sim, index|
        if sim == selected_sim
            updated_sim_selections.delete_at(index)
            updated_sim_selections.insert(index, {:name => "#{selected_sim}", :disabled => "(already selected)" })
        else 
            next
        end
    end
    recipient_sim = prompt.select("And who would you like #{selected_sim} to interact with?", updated_sim_selections) 
    chosen_interation = prompt.select("How would you like #{selected_sim} to interact with #{recipient_sim}?", interaction_options)
    find_trait(selected_sim) 
    # if chosen_interation == interaction_options[0] && selected_sim_trait == "friendly"
    #     probability_generator(friendly_probability)
    # elsif chosen_interation == interaction_options[1] && selected_sim_trait == "mean"
    #     probability_generator(mean_probability)
    # end
when home_menu_options[2]
    #puts rules
end
end


#when this game is ready to be shared, you need to replace your database.yml file with a template (because you don't want other people to have your database!). Maybe a git-ignore on the yml file?
#add option for erasing saved file and starting again? Maybe this could be a command line argument that wipes the yaml file

