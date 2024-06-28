class ProtectedResourceController < ApplicationController
  before_action :authenticate
end
