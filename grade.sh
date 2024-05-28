CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

#step 1 Clone the repository
git clone $1 student-submission
echo 'Finished cloning'

#step 2 Check that the student code has the correct file submitted
if [[ -f student-submission/ListExamples.java ]]; then
    echo 'File Exists'
else
    echo 'ListExamples.java does not exist'
    echo 'Grade : 0'
    exit 1
fi 

#step 3 Get the student code, the .java file with the grading tests, and any other files the script needs into the grading-area directory.
cp student-submission/ListExamples.java TestListExamples.java grading-area
cp -r lib grading-area

#step 4 ompile your tests and the student's code from the appropriate directory with the appropriate classpath commands 
cd grading-area
javac -cp $CPATH ListExamples.java TestListExamples.java
if [[ $? -ne 0 ]]; then
    echo 'Grade : 0'
    exit 1
fi

echo "this is the exit code of javac (previous command): $?"

#step 5 Run the tests
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > test_results.txt
tail -n 2 test_results.txt > grade.txt

if grep -q "Failures: " grade.txt; then
tail -c 3 grade.txt > fail.txt
    tail -c 5 fail.txt > run.txt
else
    echo 'Grade : 100'
    exit 1
fi

fail=$(cat fail.txt)
run=$(cat run.txt)
echo "Grade : $((run-fail))"




# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
