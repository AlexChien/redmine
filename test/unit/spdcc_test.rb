require File.dirname(__FILE__) + '/../test_helper'

class SpdccTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def setup
    Setting.spdcc_path = "#{RAILS_ROOT}/tmp/dataexchange"
  end

  def test_spdcc_path
    assert_equal(Spdcc::INCOMING, "#{RAILS_ROOT}/tmp/dataexchange/sftp/incoming", "INCOMING Path")
    assert_equal(Spdcc::OUTPUT, "#{RAILS_ROOT}/tmp/dataexchange/sftp/output", "OUTPUT Path")
    assert_equal(Spdcc::FAILED, "#{RAILS_ROOT}/tmp/dataexchange/failed", "FAILED Path")
    assert_equal(Spdcc::SUCCESS, "#{RAILS_ROOT}/tmp/dataexchange/success", "SUCCESS Path")
    assert_equal(Spdcc::OUTPUT_BK, "#{RAILS_ROOT}/tmp/dataexchange/output_bk", "OUTPUT_BK Path")

    assert(Spdcc.check_dir, "Check_dir failed")
    assert(Spdcc.check_files, "Check_files failed")
  end

  def test_parse_file

  end

  def test_SKTWAIT
    File.open("#{Spdcc::INCOMING}/0310-SKTWAIT-20111012","w") do |f|
      f.write("186216833241202            ")
    end
    Spdcc.parse_task
    assert(false, "Failure message.")
  end

end