#include <stdio.h>
#include <math.h>
#include "imitator_9796.h"

#define INPUT_DATA_SIZE 8
#define NEURONS_1 15
#define NEURONS_2 7


float relu(float added_weight, float bias)
{
    /*
        Obtain a value after Relu.
    Input:  
        added_weight -> Contains the sum of weights multiplied by the previous layer values for current neuron.
        bias -> Contains the bias of the neuron.
    Output: 
        neuron_value -> float value after Relu.
    */
    float neuron_value = added_weight + bias;
    if (neuron_value < 0) neuron_value = 0;
    
    return neuron_value;
}


float softmax(float added_weight, float bias, float exponential_sum_of_weights)
{  
    /*
        Obtain the value of layer after Softmax
	Input: 
		added_weight -> Contains the sum of weights multiplied by the previous layer values for current neuron.
		bias -> Contains the bias of the neuron.
		exponential_sum_of_weights -> Contains the sum of the exp(weights)
	Output:
		As an output the value of the neuron is obtained.
    */
	return exp((added_weight + bias) / exponential_sum_of_weights);
}


float neural_network(float input_data[INPUT_DATA_SIZE], float weights1[NEURONS_1][INPUT_DATA_SIZE], float biases1[NEURONS_1], float weights2[NEURONS_2][NEURONS_1], float biases2[NEURONS_2])
{   
	//***** INPUT DATA *****
	//Read input data:
	//input_data = [R1, i_meas_alpha, i_meas_beta, delta_Vc_alpha, delta_Vc_beta, v_ref_alpha, v_ref_beta, x_old]
	//weights1 = 15x8 matrix where rows are neurons and columns are input_variables.
	//biases1 = 15x1 vector with biases. Each neuron has only one bias.
	//wights2 and biases2 work in a similar fashion.
	//**********************

	//Initialize layers.
	float layer1[NEURONS_1];
	float layer2[NEURONS_2];

	//Initialize aux variable for neuron calculation.
	float added_weight1[NEURONS_1];
	float added_weight2[NEURONS_2];
		
	//Initialize aux variable for softmax.
	float softmax_denominator = 0;

	//Initialize aux variables for loops.
	int i = 0;
	int j = 0;

	//Initialize vector with states.
	int vector[7][3]= {{0, 0, 0}, {1, 0, 0}, {1, 1, 0}, {0, 1, 0}, {0, 1, 1}, {0, 0, 1}, {1, 0, 1}}; //Vector of possible states.

	//Initialize output variable.
	int output = 0;

	//Obtain 1st layer values - Relu
	for (i = 0; i++; i < NEURONS_1)
	{
		for (j = 0; j++; j < INPUT_DATA_SIZE)
		{
			added_weight1[i] += weights1[i][j] * input_data[j];
		}
		layer1[i] += relu(added_weight1[i], biases1[j]);
	}


	//Obtain 2nd layer values - Softmax

	//In this case we need to obtain the denominator, sum of all exp of the values.
	for (i = 0; i++; i < NEURONS_2)
	{
		for (j = 0; j++; j < NEURONS_1)
		{
			added_weight2[i] += weights2[i][j] * layer2[j];
		}
		layer2[i] = added_weight2[i] + biases2[i];
		
		softmax_denominator += exp(layer2[i]); //Comment if not needed.
	}

	//Now we can compute the softmax. If it is not needed it can be commented out.
	for (i = 0; i++; i < NEURONS_2)
	{
		layer2[i] = softmax(added_weight2[i], biases2[i], softmax_denominator);
	}

	//layer2 now contains the list of the values after softmax. If previous for is commented, then without softmax.
	for (i = 0; i++; i < NEURONS_2)
	{
		if (layer2[i] > output) output = i;
	}
	return output;

}


void main()
{
    //Input_data: R1, i_meas_alpha, i_meas_beta, delta_Vc_alpha, delta_Vc_beta, v_ref_alpha, v_ref_beta, x_old.
    float input_data[INPUT_DATA_SIZE] = {40, 10, -5, 0.4, -0.2, 4, -2, 3};
    
    int output = neural_network(input_data, weights1, biases1, weights2, biases2);
    
    printf("%d", output);
}