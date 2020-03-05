RSpec.describe ILove::Tracing do
  it 'has a version number' do
    expect(ILove::Tracing::VERSION).not_to be nil
  end

  let(:cfg) { ILove::Tracing::Configuration.new }

  it 'cfg defaults works' do
    cfg.service_name = 'test'

    expect(cfg.enabled?).to be_falsey
    expect(cfg.trace_sql?).to be_truthy
    expect(cfg.client_params).to match(host: 'localhost', port: 6831, service_name: 'test')
  end
end
