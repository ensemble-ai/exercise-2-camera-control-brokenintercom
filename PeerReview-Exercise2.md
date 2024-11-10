# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Marisol Costales-Juarez 
* *email:* mjcostales@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera stays smoothly locked onto the target even when using the boost.

___
### Stage 2 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera auto-scrolls and the target is unable to leave the bounds of the auto-scroll box but I think the target is supposed to be able to lag behind and get pushed by the camera rather than being updated to the camera's position when not moving this however could be a misunderstanding on my part about the stage's instructions.

___
### Stage 3 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera stays with leash distance of the target and uses catchup speed to appropriately stay behind the target even when using the boost, however, when the target is at the outward bounds of the leash it stutters really badly.

___
### Stage 4 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera stays in front of the target and the pause before moving back once the target stops is implemented well but the target stutters really badly once the camera reaches the maximum leash distance in front of it.

___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [x] Unsatisfactory

___
#### Justification ##### 
There is no stage 5 or any attempt at stage 5.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####
[Variable placement](https://github.com/ensemble-ai/exercise-2-camera-control-brokenintercom/blob/736cf58d806380a23faf5b0886dc6d0f5b4e7f42/Obscura/scripts/camera_controllers/jack_rabbit_camera.gd#L18) - Variables should all be declared at the top of the file unless they're inside a specific function.

[Unused variables](https://github.com/ensemble-ai/exercise-2-camera-control-brokenintercom/blob/736cf58d806380a23faf5b0886dc6d0f5b4e7f42/Obscura/scripts/camera_controllers/jack_rabbit_camera.gd#L28) - cpos and tpos are defined in multiple files and yet they remain mostly unused even when the values they represent like global_position are used multiple times within the file. 
#### Style Guide Exemplars ####
[Consistent line spacing](https://github.com/ensemble-ai/exercise-2-camera-control-brokenintercom/blob/736cf58d806380a23faf5b0886dc6d0f5b4e7f42/Obscura/scripts/camera_controllers/position_lock.gd#L12) - All space around logic within functions as well as space between functions consistently follows the godot style guide.
___

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####
[Draw position](https://github.com/ensemble-ai/exercise-2-camera-control-brokenintercom/blob/736cf58d806380a23faf5b0886dc6d0f5b4e7f42/Obscura/scripts/camera_selector.gd#L29)- Within the instructions it says that draw position should default be set to true so it shows when you swap cameras but it is default set to false within the code.

#### Best Practices Exemplars ####
[Good commenting](https://github.com/ensemble-ai/exercise-2-camera-control-brokenintercom/blob/736cf58d806380a23faf5b0886dc6d0f5b4e7f42/Obscura/scripts/camera_controllers/shmup_camera.gd#L16) - Almost every logical section of code has a descriptive comment of what its doing above it and the comments are very helpful when reading the code while also being concise!