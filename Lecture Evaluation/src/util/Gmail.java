package util;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Gmail extends Authenticator{
//Gmailsmtp�� �̿��ϱ� ���� gmail�� �̿��ؼ� email ������ ���
//Gmail ��ƿ�� ����ϱ� ���ؼ� �ܺ� ��ƿ��Ƽ 2���� ����ؾ���
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication("������", "��й�ȣ");
	}
}
