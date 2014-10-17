# A sample Guardfile
# More info at https://github.com/guard/guard#readme

opts = { cmd: 'rspec', all_on_start: true }

guard :rspec, opts do
  watch(%r{^spec/.+\.spec\.rb$}) { "spec/*" }
  watch(%r{^lib/.+\.rb$})        { "spec/*" }
end
