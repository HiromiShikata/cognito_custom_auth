import { DefineAuthChallengeTriggerHandler } from 'aws-lambda';
export const handler: DefineAuthChallengeTriggerHandler = async (event) => {
  if (
    event.request.session &&
    event.request.session.find(
      (attempt) => attempt.challengeName !== 'CUSTOM_CHALLENGE',
    )
  ) {
    event.response.issueTokens = false;
    event.response.failAuthentication = true;
  } else if (
    event.request.session &&
    event.request.session.length >= 3 &&
    event.request.session.slice(-1)[0].challengeResult == false
  ) {
    event.response.issueTokens = false;
    event.response.failAuthentication = true;
  } else if (
    event.request.session &&
    event.request.session.length &&
    event.request.session.slice(-1)[0].challengeName === 'CUSTOM_CHALLENGE' &&
    event.request.session.slice(-1)[0].challengeResult == true
  ) {
    event.response.issueTokens = true;
    event.response.failAuthentication = false;
  } else {
    event.response.issueTokens = false;
    event.response.failAuthentication = false;
    event.response.challengeName = 'CUSTOM_CHALLENGE';
  }
  return event;
};
