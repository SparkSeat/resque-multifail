require 'spec_helper'

describe Resque::Multifail do
  before(:each) do
    Resque::Failure::Multifail.clear
  end

  let(:bad_string) { [39, 52, 127, 86, 93, 95, 39].map(&:chr).join }
  let(:exception)  { StandardError.exception(bad_string) }
  let(:worker)     { Resque::Worker.new(:test) }
  let(:queue)      { 'queue' }
  let(:payload)    { { 'class' => ExampleJob, 'args' => [2, 3] } }
  let(:payload2)   { { 'class' => ExampleJob, 'args' => [3, 4] } }
  let(:backend)    { Resque::Failure::Multifail.new(exception, worker, queue, payload) }
  let(:backend2)   { Resque::Failure::Multifail.new(exception, worker, queue, payload2) }

  it 'should comply with the plugin spec' do
    Resque::Plugin.lint(Resque::Plugins::Multifail)
  end

  it 'should clear any failed jobs when failures are cleared' do
    backend.save

    expect(Resque::Failure::Multifail.job_failures(payload)).to eq 1

    Resque::Failure::Multifail.clear

    expect(Resque::Failure::Multifail.job_failures(payload)).to eq 0
  end

  it 'should record how many times a job has failed' do
    backend.save

    expect(Resque::Failure::Multifail.job_failures(payload)).to eq 1

    backend.save
    backend.save

    expect(Resque::Failure::Multifail.job_failures(payload)).to eq 3
  end

  it 'should mark the job as failed if it has exceeded the allowed number of failures' do
    expect(Resque::Failure::Multifail.count).to eq 0

    backend.save
    backend.save
    backend.save

    expect(Resque::Failure::Multifail.count).to eq 0

    backend.save

    expect(Resque::Failure::Multifail.count).to eq 1
  end

  it 'should record jobs with different arguments separately' do
    backend.save
    backend2.save

    expect(Resque::Failure::Multifail.job_failures(payload)).to eq 1
    expect(Resque::Failure::Multifail.job_failures(payload2)).to eq 1

    backend.save
    backend.save

    expect(Resque::Failure::Multifail.count).to eq 0

    backend.save

    backend2.save
    backend2.save

    expect(Resque::Failure::Multifail.count).to eq 1

    backend2.save

    expect(Resque::Failure::Multifail.count).to eq 2
  end

  it 'should clear the failed count when a job runs successfully' do
    backend.save
    backend2.save

    expect(Resque::Failure::Multifail.job_failures(payload)).to eq 1
    expect(Resque::Failure::Multifail.job_failures(payload2)).to eq 1

    resque_job = Resque::Job.new(:test, payload)
    resque_job.perform

    expect(Resque::Failure::Multifail.job_failures(payload)).to eq 0
    expect(Resque::Failure::Multifail.job_failures(payload2)).to eq 1
  end
end
