
#include <stdio.h>

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
    if (neron_value < 0) neuron_value = 0;
    
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

float neural_network(float[INPUT_DATA_SIZE] input_data, float[NEURONS_1][INPUT_DATA_SIZE] weghts1, float[NEURONS_1] biases1, float[NEURONS_2][INPUT_DATA_SIZE] weights2, float[NEURONS_2] biases2)
{   
    //***** INPUT DATA *****
    //Read input data:
    //input_data = [R1, i_meas_alpha, i_meas_beta, delta_Vc_alpha, delta_Vc_beta, v_ref_alpha, v_ref_beta, x_old]
    //weights1 = 15x8 matrix where rows are neurons and columns are input_variables.
    //biases1 = 15x1 vector with biases. Each neuron has only one bias.
    //wights2 and biases2 work in a similar fashion.
    //**********************
	
    float layer1[NEURONS_1];
    float layer2[NEURONS_2];
	
    float added_weight1[NEURONS_1] = 0;
	float added_weight2[NEURONS_2] = 0;
	    
    float softmax_denominator = 0;
	
    //Obtain 1st layer values - Relu
    for (i = 0; i++; i < NEURONS_1)
    {
        for (j = 0; j++; j < INPUT_DATA_SIZE)
        {
            added_weight1[i] += weight[i][j] * input_data[j];
        }
		layer1[i] += relu(added_weight1[i], biases1[j]);
    }
    
    
    //Obtain 2nd layer values - Softmax
    
    //In this case we need to obtain the denominator, sum of all exp of the values.
    for (i = 0; i++; i < NEURONS_2)
    {
        for (j = 0; j++; j < INPUT_DATA_SIZE)
        {
            added_weight2[i] += weights2[i][j] * layer[j];
        }
		layer2[i] = added_weight2[i] + biases2[i];
		softmax_denominator += exp(layer2[i]); //Comment if not needed for efficiency.
    }
    
    //Now we can compute the softmax.
    for (i = 0; i++; i < NEURONS_2)
    {
		layer2[i] = softmax(added_weight2[i], biases2[i], softmax_denominator);
    }
}

void main()
{
	
}