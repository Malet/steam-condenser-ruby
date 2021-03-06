# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2010-2012, Sebastian Staudt

require 'multi_json'

require 'steam-condenser/community/steam_id'
require 'steam-condenser/community/web_api'

module SteamCondenser::Community

  # Represents the special Team Fortress 2 item Golden Wrench. It includes the
  # ID of the item, the serial number of the wrench, a reference to the SteamID
  # of the owner and the date this player crafted the wrench
  #
  # @author Sebastian Staudt
  class TF2GoldenWrench

    # Returns the date this Golden Wrench has been crafted
    #
    # @return [Time] The crafting date of this wrench
    attr_reader :date

    # Returns the unique item ID of this Golden Wrench
    #
    # @return [Fixnum] The ID of this wrench
    attr_reader :id

    # Returns the serial number of this Golden Wrench
    #
    # @return [Fixnum] The serial of this wrench
    attr_reader :number

    # Returns the SteamID of the owner of this Golden Wrench
    #
    # @return [SteamId] The owner of this wrench
    attr_reader :owner

    @@golden_wrenches = nil

    # Returns all Golden Wrenches
    #
    # @raise [Error] if an error occurs querying the Web API or the Steam
    #        Community
    # @return [Array<GoldenWrench>] All Golden Wrenches
    def self.golden_wrenches
      if @@golden_wrenches.nil?
        @@golden_wrenches = []

        data = WebApi.json 'ITFItems_440', 'GetGoldenWrenches', 2
        data[:results][:wrenches].each do |wrench_data|
          @@golden_wrenches << TF2GoldenWrench.new(wrench_data)
        end
      end

      @@golden_wrenches
    end

    private

    # Creates a new instance of a Golden Wrench with the given data
    #
    # @param [Hash<Symbol, Object>] wrench_data The JSON data for this wrench
    def initialize(wrench_data)
      @date   = Time.at(wrench_data[:timestamp])
      @id     = wrench_data[:itemID]
      @number = wrench_data[:wrenchNumber]
      @owner  = SteamId.new(wrench_data[:steamID], false)
    end

  end
end
