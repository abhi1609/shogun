INCLUDE_DIRECTORIES(${INCLUDES} ${CMAKE_SOURCE_DIR}/src)
if(SYSTEM_INCLUDES)
	INCLUDE_DIRECTORIES(SYSTEM ${SYSTEM_INCLUDES})
endif()

SET(EXAMPLES 
	basic_minimal 
	classifier_libsvm 
	classifier_libsvm_probabilities
	classifier_minimal_svm 
	classifier_mklmulticlass 
	classifier_gaussian_process_binary_classification 
	classifier_gaussiannaivebayes 
	classifier_multiclasslibsvm 
	classifier_qda 
	classifier_lda 
	classifier_multiclasslinearmachine 
	classifier_knn 
	kernel_gaussian kernel_revlin kernel_custom
	library_dyn_int library_gc_array library_indirect_object 
	library_hash parameter_set_from_parameters 
	parameter_iterate_float64 parameter_iterate_sgobject 
	parameter_modsel_parameters 
	evaluation_cross_validation_classification 
	evaluation_cross_validation_regression 
	evaluation_cross_validation_locked_comparison 
	evaluation_cross_validation_multiclass 
	evaluation_cross_validation_multiclass_mkl 
	evaluation_cross_validation_mkl_weight_storage 
	modelselection_parameter_combination_test 
	regression_gaussian_process_fitc 
	regression_gaussian_process_gaussian 
	regression_gaussian_process_sum 
	regression_gaussian_process_product 
	regression_gaussian_process_ard 
	regression_gaussian_process_laplace 
	regression_gaussian_process_simple_exact 
	modelselection_model_selection_parameters_test 
	modelselection_parameter_tree 
	modelselection_apply_parameter_tree 
	modelselection_grid_search_linear features_subset_labels 
	modelselection_grid_search_kernel 
	modelselection_grid_search_string_kernel 
	modelselection_grid_search_multiclass_svm 
	modelselection_combined_kernel_sub_parameters 
	features_dense_real_modular 
	features_subset_stack 
	features_subset_simple_features 
	features_copy_subset_simple_features 
	features_copy_subset_sparse_features 
	labels_binary_fit_sigmoid 
	mathematics_confidence_intervals 
	clustering_kmeans base_parameter_map 
	base_load_file_parameters 
	base_load_all_file_parameters 
	base_map_parameters 
	base_migration_type_conversion 
	base_migration_dropping_and_new 
	base_migration_multiple_dependencies 
	splitting_stratified_crossvalidation 
	splitting_standard_crossvalidation 
	library_set 
	library_map 
	mathematics_lapack 
	converter_locallylinearembedding 
	converter_localtangentspacealignment 
	converter_hessianlocallylinearembedding 
	converter_kernellocallylinearembedding 
	converter_multidimensionalscaling 
	converter_isomap
	converter_jade_bss  
	converter_diffusionmaps 
	converter_laplacianeigenmaps 
	converter_neighborhoodpreservingembedding 
	converter_linearlocaltangentspacealignment 
	converter_localitypreservingprojections 
	converter_stochasticproximityembedding 
	converter_factoranalysis 
	serialization_basic_tests 
	serialization_multiclass_labels 
	kernel_machine_train_locked 
	statistics 
	transfer_multitaskleastsquaresregression 
	transfer_multitasklogisticregression 
	statistics_quadratic_time_mmd 
	statistics_linear_time_mmd 
	statistics_mmd_kernel_selection 
	statistics_hsic 
	classifier_featureblocklogisticregression 
	so_multiclass_BMRM 
	balanced_conditional_probability_tree 
	classifier_multiclass_ecoc 
	classifier_multiclass_ecoc_discriminant 
	classifier_multiclass_ecoc_random 
	streaming_from_dense 
	library_mldatahdf5
	library_hdf5 
	library_serialization 
	classifier_svmlight_string_features_precomputed_kernel 
	classifier_mkl_svmlight_modelselection_bug 
	base_migration_new_buggy 
	regression_libsvr 
	classifier_multiclass_prob_heuristics 
	streaming_onlineliblinear 
	io_linereader 
	library_circularbuffer 
	so_factorgraph 
)

IF (USE_MOSEK)
	LIST(APPEND EXAMPLES so_fg_model so_multiclass)
ENDIF ()

FOREACH(EXAMPLE ${EXAMPLES})
	add_executable(${EXAMPLE} ${CMAKE_CURRENT_SOURCE_DIR}/${EXAMPLE}.${EXT_SRC_CPP})
	target_link_libraries(${EXAMPLE} shogun ${SANITIZER_LIBRARY})
	IF(SANITIZER_FLAGS)
		set_target_properties(${EXAMPLE} PROPERTIES COMPILE_FLAGS ${SANITIZER_FLAGS})
	ENDIF()
	add_test(libshogun-${EXAMPLE} ${CMAKE_CURRENT_BINARY_DIR}/${EXAMPLE})
	set_property(TEST libshogun-${EXAMPLE} PROPERTY
 		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
	LIST(APPEND INSTALL_EXAMPLES ${CMAKE_CURRENT_BINARY_DIR}/${EXAMPLE})
ENDFOREACH()

INSTALL(FILES ${INSTALL_EXAMPLES}
	DESTINATION share/shogun/examples/libshogun
	COMPONENT libshogun-examples)

SET(CPACK_COMPONENTS_ALL ${CPACK_COMPONENTS_ALL} libshogun-examples PARENT_SCOPE)
