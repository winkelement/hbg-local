require_relative '../test_helper'

describe OfferMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:offer) { offers(:basic) }

  describe '#expiring_mail' do
    it 'must deliver' do
      mail = OfferMailer.expiring_mail 1, [offer.id]
      mail.must deliver_from 'post@clarat.org'
      mail.must have_body_text '1 offer expired today:'
      mail.must have_body_text offer.id.to_s
    end
  end

  describe '#inform' do
    let(:contact_person) do
      FactoryGirl.create :contact_person,
                         { email_address: 'foo@bar.baz',
                           offers: [offers(:basic)] }.merge(options)
    end
    let(:options) { {} }
    let(:email) { contact_person.email }

    subject { OfferMailer.inform email }

    it 'must deliver and update the email log' do
      email.expects(:update_log)
      subject.must deliver_to 'foo@bar.baz'
      subject.must have_body_text 'clarat'
    end

    describe 'for a genderless contact person without a name' do
      let(:options) do
        { gender: nil, first_name: nil, last_name: nil, local_number_1: '1' }
      end

      it 'must address them correctly' do
        subject.must have_body_text 'Sehr geehrte Damen und Herren,'
      end
    end

    describe 'for an email with multiple contact people' do
      it 'must address them correctly' do
        FactoryGirl.create :contact_person, email_address: nil,
                                            email: contact_person.email
        subject.must have_body_text 'Sehr geehrte Damen und Herren,'
      end
    end

    describe 'for a male contact person with only a first name' do
      let(:options) { { gender: 'male', first_name: 'Foobar', last_name: '' } }

      it 'must address them correctly' do
        subject.must have_body_text 'Lieber Foobar,'
      end
    end

    describe 'for a male contact person with first and last name' do
      let(:options) { { gender: 'male', first_name: 'X', last_name: 'Bar' } }

      it 'must address them correctly' do
        subject.must have_body_text 'Lieber Herr Bar,'
      end
    end

    describe 'for a female contact person with only a last name' do
      let(:options) { { gender: 'female', first_name: '', last_name: 'Baz' } }

      it 'must address them correctly' do
        subject.must have_body_text 'Liebe Frau Baz,'
      end
    end

    describe 'for a female contact person with only a first name' do
      let(:options) { { gender: 'female', first_name: 'Fuz', last_name: nil } }

      it 'must address them correctly' do
        subject.must have_body_text 'Liebe Fuz,'
      end
    end
  end
end
