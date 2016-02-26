<?php

/* -----------------------------------------------------------------------------

    VARIABLES

----------------------------------------------------------------------------- */

// email where the contact form messages will be sent
$email_to = 'example@example.com';

// sucess message
$success_msg = 'Message sent successfully!';

// connection error message
$connection_error_msg = 'There was a connection problem. Try again later.';

// required fields message
$required_fields_error_msg = 'Fields with (*) are required!';

// spam detected error message
$spam_error_message = 'Leave the field after the email field blank please.';

// errors in form message
$multiple_errors_msg = 'Fix the following errors, please:';

// name error message
$name_error_msg = 'The Name you entered does not appear to be valid.';

// email error message
$email_error_msg = 'The Email Address you entered does not appear to be valid.';

// email subject
$email_subject = 'New reservation';

// email text
$email_text = 'Form details below:';


/* -----------------------------------------------------------------------------

    FORM

----------------------------------------------------------------------------- */

if( isset( $_REQUEST['reservation-form'] ) ) {

    function died( $error ) {
        echo '<p class="c-alert-message m-warning m-phpvalidation-error" style="display: none;"><i class="ico fa fa-exclamation-circle"></i><strong>' . $multiple_errors_msg . '</strong>' . $error . '</p>';
        die();
    }

	function secure_string( $string ) {
		$string = strip_tags( $string );
		$string = htmlspecialchars( $string, ENT_QUOTES );
		$string = trim( $string );
		return $string;
	}

	/* -------------------------------------------------------------------------
        CHECK IF REQUIRED FIELDS EXISTS
    ------------------------------------------------------------------------- */

    if( !isset( $_REQUEST['reservation-name'] ) ||
        ! ( isset( $_REQUEST['reservation-email'] ) || isset( $_REQUEST['reservation-phone'] ) ) ) {
        died( $required_fields_error_msg );
    }
	// honeypot
	if ( isset( $_REQUEST['reservation-email-hp'] ) && $_REQUEST['reservation-email-hp'] !== '' ) {
		died( $spam_error_message );
	}

	/* -------------------------------------------------------------------------
        VALIDATE / PROCESS FIELDS
    ------------------------------------------------------------------------- */

	$error_message = '';

	// SERVICES
	if ( isset( $_REQUEST['reservation-services'] ) ) {
		$services = $_REQUEST['reservation-services'];
		$services_text = '';
		for ( $i=0; $i < count( $services ); $i++ ) {
			$services_text.= $services[$i];
			if ( $i < count( $services ) ) {
				$services_text.= ', ';
			}
		}
		$field_services = secure_string( $services_text );
	}

	// NAME
    $field_name = secure_string( $_REQUEST['reservation-name'] );
    if ( strlen( $field_name ) < 1 ) {
        $error_message .= '<br>' . name_error_msg;
    }

	// EMAIL
	if ( isset( $_REQUEST['reservation-email'] ) && strlen( $_REQUEST['reservation-email'] ) > 0 ) {
		$field_email = secure_string( $_REQUEST['reservation-email'] );
		$email_exp = '/^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/';
		if ( !preg_match( $email_exp, $field_email ) ) {
			$error_message .= '<br>' . $email_error_msg;
		}
	}

	// PHONE
    if ( isset( $_REQUEST['reservation-phone'] ) ) {
        $field_phone = secure_string( $_REQUEST['reservation-phone'] );
    }

	// DATE
    if ( isset( $_REQUEST['reservation-date'] ) ) {
        $field_date = secure_string( $_REQUEST['reservation-date'] );
    }

	// TIME
    if ( isset( $_REQUEST['reservation-time'] ) ) {
        $field_time = secure_string( $_REQUEST['reservation-time'] );
    }

	// NOTE
	if ( isset( $_REQUEST['reservation-note'] ) ) {
		$field_note = secure_string( $_REQUEST['reservation-note'] );
	}

	// END IF THERE IS AT LEAST ONE ERROR MESSAGE
    if ( strlen( $error_message ) > 0 ) {
        died( $error_message );
    }

	/* -------------------------------------------------------------------------
        SEND EMAIL
    ------------------------------------------------------------------------- */

    function clean_string( $string ) {
        $bad = array( 'content-type', 'bcc:', 'to:', 'cc:', 'href' );
        return str_replace( $bad, '', $string );
    }
	$email_message = $email_text . "\n\n";

	if ( isset( $field_services ) ) {
		$email_message .= 'Services: ' . clean_string( $field_services ) . "\n";
	}
    $email_message .= 'Name: ' . clean_string( $field_name ) . "\n";
	if ( isset( $field_email ) ) {
		$email_message .= 'Email: ' . clean_string( $field_email ) . "\n";
	}
    if ( isset( $field_phone ) ) {
        $email_message .= 'Phone: ' . clean_string( $field_phone ) . "\n";
    }
    if ( isset( $field_date ) ) {
        $email_message .= 'Date: ' . clean_string( $field_date ) . "\n";
    }
    if ( isset( $field_time ) ) {
        $email_message .= 'Time: ' . clean_string( $field_time ) . "\n";
    }
	if ( isset( $field_note ) ) {
		$email_message .= "\n" . clean_string( $field_note ) . "\n";
	}
    $headers = 'MIME-Version: 1.0' . "\r\n" . 'Content-type: text/plain; charset=UTF-8' . "\r\n" .
	'From: ' . $field_email . "\r\n" .
    'Reply-To: ' . $field_email . "\r\n" .
    'X-Mailer: PHP/' . phpversion();

    @mail( $email_to, '=?utf-8?B?' . base64_encode( $email_subject ) . '?=', $email_message, $headers );

	/* -------------------------------------------------------------------------
        OUTPUT SUCCESS MESSAGE
    ------------------------------------------------------------------------- */

    echo '<p class="c-alert-message m-success" style="display: none;"><i class="ico fa fa-check-circle"></i>' . $success_msg . '</p>';

}
else {

	/* -------------------------------------------------------------------------
        CONNECTION PROBLEM MESSAGE
    ------------------------------------------------------------------------- */

	echo '<p class="c-alert-message m-warning m-request-error" style="display: none;"><i class="ico fa fa-exclamation-circle"></i>' . $connection_error_msg . '</p>';

}

?>