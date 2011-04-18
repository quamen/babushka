# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Add files and commands to this file, like the example:
#   watch('file/path') { `command(s)` }
#
guard 'shell' do
  watch(/(.*).rb/) {|m| `rocco #{m[0]}` }
end

guard 'livereload' do
  watch(%r{examples/.+\.html})
end
