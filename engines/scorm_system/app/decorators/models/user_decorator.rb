FreeLearn::User.class_eval do
has_many :scorms, class_name: FreeLearn::ScormSystem::Scorm
end