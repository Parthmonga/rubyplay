require 'rubygems'
require 'stemmer'
require 'classifier'
require 'yaml'

# Load previous classifications
lovedme       = YAML::load_file('lovedme.yml')
not_lovedme = YAML::load_file('not_lovedme.yml')

# Create our Bayes / LSI classifier
classifier = Classifier::Bayes.new('Lovedme', 'Not Lovedme')

# Train the classifier
not_lovedme.each { |boo| classifier.train_not_lovedme boo }
lovedme.each { |good_one| classifier.train_lovedme good_one }

# Let's classify some new quotes
puts classifier.classify "Christina: same height, brown hair, brown eyes, thin"

# Print the classifier itself
p classifier
