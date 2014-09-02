#!/bin/bash
################################################
# bash script                                  #
# author Mikolaj 'Metatron' Niedbala           #
# displays user crontab in human readable form #
# based on `crontab` command                   #
# need to specify user                         #
# licenced GNU/ GPL                            #
################################################

if [[ -z $1 ]]; then
	echo "Podaj uzytkownika CRON, dla ktorego wyswietlic tabele"
	exit 1;
fi;

echo -e "Lista komend do wykonania dla uzytkownika $1\n"	
crontab -l -u $1 | while read line
	do 
		if [[ ! $line =~ ^\# && ! -z $line ]]; then
			COMBINED_DATE=0
			TIME_str=""
			DATE_str=""
		
			#explode to values
			COMMAND=`echo "$line" | sed 's/^\(.\{1,8\} \)\{5\}//'`
			MINUTES=`echo "$line" |cut -d" " -f1`
			HOUR=`echo "$line" |cut -d" " -f2`
			MONTH_DAY=`echo "$line" |cut -d" " -f3`
			MONTH=`echo "$line" |cut -d" " -f4`
			WEEK_DAY=`echo "$line" |cut -d" " -f5`
			
			#command string
			ECHO_str="komenda $COMMAND zostanie wykonana"
			
			#process values
				#hours
				if [[ ! $HOUR =~ ^\*$ && ! -z $HOUR ]]; then
					if [[ $HOUR =~ ^\*\/[0-9]{1,2}$ && ! -z $HOUR ]]; then
						NUM_HOUR=`echo "$HOUR" |cut -d"/" -f2`;
						HR_str="co $NUM_HOUR godzin";
					elif [[ $HOUR =~ ^[0-9]{1,2}$ && ! -z $HOUR ]]; then
						HR_str="o godzinie $HOUR"
						COMBINED_DATE=1
					elif [[ $HOUR =~ ^[0-9]{1,2}-[0-9]{1,2}$ && ! -z $HOUR ]]; then
						FR_NUM_HOUR=`echo "$HOUR" |cut -d"-" -f1`;
						TO_NUM_HOUR=`echo "$HOUR" |cut -d"-" -f2`;
						HR_str="pomiedzy godzina $FR_NUM_HOUR a $TO_NUM_HOUR"				
					elif [[ $HOUR =~ ^[0-9]{1,2}-[0-9]{1,2}\/[0-9]{1,2}$ && ! -z $HOUR ]]; then
						NUM_HOUR=`echo "$HOUR" |cut -d"/" -f2`;
						HOUR_RANGE=`echo "$HOUR" |cut -d"/" -f1`;
						FR_NUM_HOUR=`echo "$HOUR_RANGE" |cut -d"-" -f1`;
						TO_NUM_HOUR=`echo "$HOUR_RANGE" |cut -d"-" -f2`;
						HR_str="pomiedzy godzina $FR_NUM_HOUR a $TO_NUM_HOUR, co $NUM_HOUR godziny"
					fi;
				else
					HR_str=""
				fi;
				
				#minutes
				if [[ ! $MINUTES =~ ^\*$ && ! -z $MINUTES ]]; then
					if [[ $MINUTES =~ ^\*\/[0-9]{1,2}$ && ! -z $MINUTES ]]; then
						NUM_MINUTES=`echo "$MINUTES" |cut -d"/" -f2`
						MIN_str="co $NUM_MINUTES minut"
					elif [[ $COMBINED_DATE == 1 ]]; then
						if [[ ! $MINUTES =~ ^\*$ && ! -z $MINUTES ]]; then
							MIN_str="$MINUTES"
						else
							MIN_str="w $MINUTES minucie"
						fi;
					elif [[ $MINUTES =~ ^[0-9]{1,2}-[0-9]{1,2}$ && ! -z $MINUTES ]]; then
						FR_NUM_MINUTES=`echo "$MINUTES" |cut -d"-" -f1`;
						TO_NUM_MINUTES=`echo "$MINUTES" |cut -d"-" -f2`;
						MIN_str="pomiedzy $FR_NUM_MINUTES a $TO_NUM_MINUTES minuta"						
					elif [[ $MINUTES =~ ^[0-9]{1,2}-[0-9]{1,2}\/[0-9]{1,2}$ && ! -z $MINUTES ]]; then
						NUM_MINUTES=`echo "$MINUTES" |cut -d"/" -f2`;
						MINUTES_RANGE=`echo "$MINUTES" |cut -d"/" -f1`;
						FR_NUM_MINUTES=`echo "$MINUTES_RANGE" |cut -d"-" -f1`;
						TO_NUM_MINUTES=`echo "$MINUTES_RANGE" |cut -d"-" -f2`;
						MIN_str="pomiedzy $FR_NUM_MINUTES a $TO_NUM_MINUTES minuta, co $NUM_MINUTES minuty"
					fi;					
				else
					MIN_str=""
				fi;		
				
				#day of month
				if [[ ! $MONTH_DAY =~ ^\*$ && ! -z $MONTH_DAY ]]; then
					if [[ $MONTH_DAY =~ ^\*\/[0-9]{1,2}$ && ! -z $MONTH_DAY ]]; then
						NUM_MONTH_DAY=`echo "$MONTH_DAY" |cut -d"/" -f2`
						MON_D_str="co $NUM_MONTH_DAY dni"
					elif [[ $MONTH_DAY =~ ^[0-9]{1,2}$ && ! -z $MONTH_DAY ]]; then
						MON_D_str="$MONTH_DAY dnia miesiaca"
					elif [[ $MONTH_DAY =~ ^[0-9]{1,2}-[0-9]{1,2}$ && ! -z $MONTH_DAY ]]; then
						FR_NUM_MONTH_DAY=`echo "$MONTH_DAY" |cut -d"-" -f1`;
						TO_NUM_MONTH_DAY=`echo "$MONTH_DAY" |cut -d"-" -f2`;
						MON_D_str="pomiedzy $FR_NUM_MONTH_DAY a $TO_NUM_MONTH_DAY dniem miesiaca"						
					elif [[ $MONTH_DAY =~ ^[0-9]{1,2}-[0-9]{1,2}\/[0-9]{1,2}$ && ! -z $MONTH_DAY ]]; then
						NUM_MONTH_DAY=`echo "$MONTH_DAY" |cut -d"/" -f2`;
						MONTH_DAY_RANGE=`echo "$MONTH_DAY" |cut -d"/" -f1`;
						FR_NUM_MONTH_DAY=`echo "$MONTH_DAY_RANGE" |cut -d"-" -f1`;
						TO_NUM_MONTH_DAY=`echo "$MONTH_DAY_RANGE" |cut -d"-" -f2`;
						MON_D_str="pomiedzy $FR_NUM_MONTH_DAY a $TO_NUM_MONTH_DAY dniem miesiaca, co $NUM_MONTH_DAY dni"
					fi;						
				else
					MON_D_str=""
				fi;				
				
				#month
				if [[ ! $MONTH =~ ^\*$ && ! -z $MONTH ]]; then
					if [[ $MONTH =~ ^\*\/[0-9]{1,2}$ && ! -z $MONTH ]]; then
						NUM_MONTH=`echo "$MONTH" |cut -d"/" -f2`
						MON_str="co $NUM_MONTH miesiecy"
					elif [[ $MONTH =~ ^[0-9]{1,2}$ && ! -z $MONTH ]]; then
						MON_str="w $MONTH miesiacu"
					elif [[ $MONTH =~ ^[0-9]{1,2}-[0-9]{1,2}$ && ! -z $MONTH ]]; then
						FR_NUM_MONTH=`echo "$MONTH" |cut -d"-" -f1`;
						TO_NUM_MONTH=`echo "$MONTH" |cut -d"-" -f2`;
						MON_str="pomiedzy $FR_NUM_MONTH a $TO_NUM_MONTH miesiacem"						
					elif [[ $MONTH =~ ^[0-9]{1,2}-[0-9]{1,2}\/[0-9]{1,2}$ && ! -z $MONTH ]]; then
						NUM_MONTH=`echo "$MONTH" |cut -d"/" -f2`;
						MONTH_RANGE=`echo "$MONTH" |cut -d"/" -f1`;
						FR_NUM_MONTH=`echo "$MONTH_RANGE" |cut -d"-" -f1`;
						TO_NUM_MONTH=`echo "$MONTH_RANGE" |cut -d"-" -f2`;
						MON_str="pomiedzy $FR_NUM_MONTH a $TO_NUM_MONTH miesiacem, co $NUM_MONTH miesiecy"
					fi;						
				else
					MON_str=""
				fi;				
				
				#week day
				if [[ ! $WEEK_DAY =~ ^\*$ && ! -z $WEEK_DAY ]]; then
					if [[ $WEEK_DAY =~ ^\*\/[0-9]{1,2}$ && ! -z $WEEK_DAY ]]; then
						NUM_WEEK=`echo "$WEEK_DAY" |cut -d"/" -f2`
						WEK_str="co $NUM_WEEK dni tygodnia"
					elif [[ $WEEK_DAY =~ ^[0-9]{1,2}$ && ! -z $WEEK_DAY ]]; then
						WEK_str="$WEEK_DAY dnia tygodnia"
					elif [[ $WEEK_DAY =~ ^[0-9]{1,2}-[0-9]{1,2}$ && ! -z $WEEK_DAY ]]; then
						FR_NUM_WEEK_DAY=`echo "$WEEK_DAY" |cut -d"-" -f1`;
						TO_NUM_WEEK_DAY=`echo "$WEEK_DAY" |cut -d"-" -f2`;
						WEK_str="pomiedzy $FR_NUM_WEEK_DAY a $TO_NUM_WEEK_DAY dniem tygodnia"						
					elif [[ $WEEK_DAY =~ ^[0-9]{1,2}-[0-9]{1,2}\/[0-9]{1,2}$ && ! -z $WEEK_DAY ]]; then
						NUM_WEEK_DAY=`echo "$WEEK_DAY" |cut -d"/" -f2`;
						WEEK_DAY_RANGE=`echo "$WEEK_DAY" |cut -d"/" -f1`;
						FR_NUM_WEEK_DAY=`echo "$WEEK_DAY_RANGE" |cut -d"-" -f1`;
						TO_NUM_WEEK_DAY=`echo "$WEEK_DAY_RANGE" |cut -d"-" -f2`;
						MON_str="pomiedzy $FR_NUM_WEEK_DAY a $TO_NUM_WEEK_DAY dniem tygodnia, co $NUM_WEEK_DAY dni"
					fi;						
				else
					WEK_str=""
				fi;
				
			#generate string for end user
			if [[ $COMBINED_DATE == 1 ]]; then
				if [[ $MIN_str =~ ^[0-9]{1}$ ]]; then
					MIN_str="0$MIN_str"
				fi;					
				TIME_str="$HR_str:$MIN_str, "
			else
				if [[ ! -z $HR_str ]]; then
					TIME_str="$HR_str, "
				else
					TIME_str="$TIME_str$MIN_str, "
				fi;	
			fi;
				
			if [[ ! -z $WEK_str || ! -z $MON_str || ! -z $MON_D_str ]]; then
				if [[ ! -z $WEK_str ]]; then
					DATE_str="$WEK_str, "
				fi;	
				if [[ ! -z $MON_str ]]; then
					DATE_str="$DATE_str$MON_str, "
				fi;	
				if [[ ! -z $MON_D_str ]]; then
					DATE_str="$DATE_str$MON_D_str, "
				fi;					
			else
				DATE_str="codziennie"
			fi;	
							
			if [[ $DATE_str =~ ^codziennie$ ]]; then
				echo "-+ $ECHO_str $DATE_str $TIME_str" | sed 's/.\{2\}$//'
			else				
				echo "-+ $ECHO_str $TIME_str $DATE_str" | sed 's/.\{2\}$//'
			fi;	
			
			echo "--"	
		fi;
done;
exit 0;
