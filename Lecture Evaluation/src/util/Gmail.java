package util;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Gmail extends Authenticator{
//Gmailsmtp를 이용하기 위해 gmail을 이용해서 email 보내기 기능
//Gmail 유틸을 사용하기 위해선 외부 유틸리티 2가지 사용해야함
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication("지메일", "비밀번호");
	}
}
