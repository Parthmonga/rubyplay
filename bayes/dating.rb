require 'rubygems'
require 'stemmer'
require 'classifier'
require 'yaml'

# Load previous classifications
interested       = YAML::load_file('interested.yml')
not_interested = YAML::load_file('not_interested.yml')

# Create our Bayes / LSI classifier
classifier = Classifier::Bayes.new('Interested', 'Not Interested')

# Train the classifier
not_interested.each { |boo| classifier.train_not_interested boo }
interested.each { |good_one| classifier.train_interested good_one }

# Let's classify some folks not interested in me
print "Christina: " 
print classifier.classify "Christina: same height, brown hair, brown eyes, thin"
print "\n"

print "Kelsey: " 
print classifier.classify "Kelsey: taller, blonde hair, blue eyes, thin"
print "\n"

# Let's classify some folks that I don't know about
print "Amara: " 
print classifier.classify "Amara: same height, black hair, brown eyes, thin"
print "\n"
print "Kaylee: " 
print classifier.classify "Kaylee: shorter, blonde hair, blue eyes, thin"
print "\n"

# Print the classifier itself
p classifier
