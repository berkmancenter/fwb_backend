describe 'Requesting accounts index' do
  context 'with auth token' do
    let(:account) { FactoryGirl.create(:account) }

    it 'will show a list of all accounts' do
      post '/sign_in',
        session: { name: account.name, password: account.password }

      get '/accounts'
      expect(response).to have_http_status(:success)
      expect(json.length).to eq(1)
    end
  end

  context 'when not authed' do
    it 'will not show any accounts' do
      get '/accounts'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
