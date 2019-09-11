
function ssh-uptime() {
	local host=$1
	echo "$host $(ssh $host uptime 2>/dev/null)"
}

function login-stat-nahpc() {
	(
		ssh-uptime login1.nahpc.arm.com &
		ssh-uptime login2.nahpc.arm.com &
		ssh-uptime login4.nahpc.arm.com &
		ssh-uptime login5.nahpc.arm.com &
		ssh-uptime login6.nahpc.arm.com &
		ssh-uptime login7.nahpc.arm.com &
		ssh-uptime login8.nahpc.arm.com &
		ssh-uptime login9.nahpc.arm.com &
		ssh-uptime login10.nahpc.arm.com &
		ssh-uptime login11.nahpc.arm.com &
		ssh-uptime login12.nahpc.arm.com &
		ssh-uptime login13.nahpc.arm.com &
		ssh-uptime login14.nahpc.arm.com &
		ssh-uptime login15.nahpc.arm.com &
		wait
	) | column -t | sort -n -k 11
}

function login-stat-nahpc2() {
	(
		ssh-uptime login1.nahpc2.arm.com &
		ssh-uptime login2.nahpc2.arm.com &
		ssh-uptime login4.nahpc2.arm.com &
		ssh-uptime login6.nahpc2.arm.com &
		ssh-uptime login7.nahpc2.arm.com &
		ssh-uptime login8.nahpc2.arm.com &
		ssh-uptime login9.nahpc2.arm.com &
		ssh-uptime login10.nahpc2.arm.com &
		wait
	) | column -t | sort -n -k 11
}

function login-stat-euhpc() {
	(
		ssh-uptime login1.euhpc.arm.com &
		ssh-uptime login2.euhpc.arm.com &
		ssh-uptime login4.euhpc.arm.com &
		ssh-uptime login5.euhpc.arm.com &
		ssh-uptime login6.euhpc.arm.com &
		ssh-uptime login7.euhpc.arm.com &
		ssh-uptime login8.euhpc.arm.com &
		ssh-uptime login9.euhpc.arm.com &
		ssh-uptime login10.euhpc.arm.com &
		ssh-uptime login11.euhpc.arm.com &
		ssh-uptime login12.euhpc.arm.com &
		wait
	) | column -t | sort -n -k 11
}

