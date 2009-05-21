Factory.define :quiz do |quiz|
  quiz.author "Dimo"
  quiz.title "A Test Quiz"
  quiz.description "This quiz is all about unit testing, it's way cool."
  quiz.posted Date.today
  quiz.summary ""
end

Factory.define :response do |r|
  r.quiz {|quiz| quiz.association :quiz}
  r.author "Testy McTestersons"
  r.body "My solution was really great, you have to see it to believe it"
end

Factory.define :user do |r|
  r.login "quentin"
  r.password "test"
  r.email "quentin@example.com"
end