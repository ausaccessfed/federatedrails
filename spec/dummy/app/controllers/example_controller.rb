class ExampleController < ApplicationController

  def index
    logger.debug security_manager.subject.inspect
    @subjects = Subject.all
  end

end
