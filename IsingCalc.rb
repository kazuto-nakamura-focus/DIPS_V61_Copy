#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# ------------------------------------------------------
#
# === Ising_Calc.rb ===
#
# Calculate Enegy for nsite-dimensional Ising Model
#     version 6.1.0
#
#   Author: Hiroki Funashima
#
#  Copyright 2012-2023, Hiroki Funashima, All Rights reserved.
#
# ------------------------------------------------------
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are  met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the distribution.
#     * Neither the name of Hiroki Funashima nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

$LOAD_PATH.push('./module')
require 'IsingHamiltonian'
require 'IsingStatistics'
configfile = 'Ising_input.data'
hamiltonian_obj = IsingHamiltonian.new(configfile)
statistical_obj = IsingStatistics.new(hamiltonian_obj)

#
# figure file infomation
#
filetype = 'png'
#
# for energy
#
figure_name = 'figure/ising_state_energy'
title = 'Total Energy(Ising Model) for Each State'
#
# for probability
#
figure_p_name = 'figure/ising_state_probability'
title_p = 'probablirty(Ising Model) for Each State'

#
# output files( log )
#
calc_log  = './output/ising_main_calc.out'
state_csv = './output/ising_state.csv'

def display_postprocess(file_io, calc_log, state_csv)
  file_io.print "\n\n ====== Summary =======\n\n"
  file_io.print "   Main Log file: #{calc_log}\n\n"
  file_io.print "      Numerical Data :#{state_csv}\n"
end

#
# prepare to display
#
require 'IsingInfo'
fout = open(calc_log, 'w')
ising_result = []
io_objs = [$stdout, fout]

io_objs.each_with_index do |io_obj, index|
  ising_result[index] = IsingInfo.new(io_obj, hamiltonian_obj, statistical_obj)
end

#
# Display results for Ising calculation
#
ising_result.each do |ising_result_obj|
  ising_result_obj.ising_header
  ising_result_obj.display_ising_input_info
  ising_result_obj.display_ising_jmatrix
  ising_result_obj.display_ising_external
  ising_result_obj.display_sigma_info
  ising_result_obj.display_ising_energies
  ising_result_obj.display_statistical_results
end

#
# write csv file
#
require 'WriteIsingResultToCsvFiles'
WriteIsingResultToCsvFiles.new(state_csv, hamiltonian_obj, statistical_obj)

#
# summary for output
#
io_objs.each do |file_io|
  display_postprocess(file_io, calc_log, state_csv)
end

ising_result.map(&:display_ising_footer)
fout.close
