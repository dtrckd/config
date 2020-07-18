MAIL_SMTP_SERVER="domain"
#MAIL_SMTP_PORT="25"
MAIL_FROM="name@domain"
MAIL_SMTP_USERNAME="usernamee"
MAIL_SMTP_PASSWORD="xxx"

swaks -4 --server "${MAIL_SMTP_SERVER}" -p "${MAIL_SMTP_PORT}" --from "${MAIL_FROM}" --body "Hi from $(hostname -f)" --auth-user "${MAIL_SMTP_USERNAME}" --auth-password "${MAIL_SMTP_PASSWORD}"
