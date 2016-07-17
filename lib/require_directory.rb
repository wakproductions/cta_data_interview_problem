module Kernel
  # Requires all the files in a directory named as the file that calls this method. It uses Rube'y 'caller'
  # feature in order to figure out the calling file. It sorts the files to require to consistently have the
  # same order across systems. The usage for this method is as simple as:
  #
  # @example Usage
  #   require_directory
  #
  # This facilitates the construction of a common pattern in our codebase, which is to create a file and a directory
  # with the same name, where the file is responsible for requiring the whole directory. An example of this pattern:
  #
  # lib/
  #   fact/
  #   fact.rb <-- this file requires the whole fact/ directory

  def require_directory(recursive: false)
    filepath = caller.first.split(':').first

    Dir["#{File.dirname(filepath)}/#{File.basename(filepath, '.rb')}#{'/**' if recursive}"].sort!.each do |file|
      require file
    end
  end
end