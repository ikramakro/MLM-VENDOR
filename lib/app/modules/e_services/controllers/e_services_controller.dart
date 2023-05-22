import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_service_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/e_service_repository.dart';

enum CategoryFilter {
  ALL,
  // AVAILABILITY,
  RATING,
  FEATURED,
  POPULAR,
}

class EServicesController extends GetxController {
  final selected = Rx<CategoryFilter>(CategoryFilter.ALL);
  final eServices = <EService>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final eProvider = <EProvider>[].obs;
  final Subcategories = <Category>[].obs;
  final SubcategoriesReuse = <Category>[].obs;
  final isDone = false.obs;
  EProviderRepository _eProviderRepository;
  EServiceRepository _eServiceRepository;
  CategoryRepository _categoryRepository;
  ScrollController scrollController = ScrollController();

  EServicesController() {
    _eProviderRepository = new EProviderRepository();
    _categoryRepository = new CategoryRepository();
    _eServiceRepository = new EServiceRepository();
  }

  @override
  Future<void> onInit() async {
    await GetEProviders();

    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //           scrollController.position.maxScrollExtent &&
    //       !isDone.value) {
    //     loadEServicesOfCategory(filter: selected.value);
    //   }
    // });
    await refreshEServices();
    print("oninit is calling ");
    super.onInit();
  }

  @override
  void onClose() {
    print("onClose is calling ");
    scrollController.dispose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("dispose is calling ");
    super.dispose();
  }

  Future refreshEServices({bool showMessage}) async {
    toggleSelected(selected.value);
    await loadEServicesOfCategory(filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of services refreshed successfully".tr));
    }
  }

  Future GetEProviders() async {
    try {
      List<EProvider> _eProviders = [];
      _eProviders = (await _eProviderRepository.getEProviders());
      if (_eProviders.isNotEmpty) {
        this.eProvider.addAll(_eProviders);
      } else {
        print("not geting any provider");
      }
      print("_eProviders value ${_eProviders[0].cat_id}");
      if (eProvider[0]?.cat_id != null) {
        print("eprovider value ${eProvider[0].cat_id}");
        await getSubCategories(_eProviders[0].cat_id);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {}
  }

  Future getSubCategories(catID) async {
    try {
      print("eprovider cat id ${eProvider[0].cat_id}");
      Subcategories.assignAll(
          await _categoryRepository.getAllWithSubCategories(catID));

      print("subCategories are $Subcategories");
    } catch (e) {
      print("this is the error ${e.toString()}");
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isSelected(CategoryFilter filter) => selected == filter;

  void toggleSelected(CategoryFilter filter) {
    this.eServices.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = CategoryFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future loadEServicesOfCategory({CategoryFilter filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<EService> _eServices = [];
      switch (filter) {
        case CategoryFilter.ALL:
          _eServices =
              await _eProviderRepository.getEServices(page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _eServices = await _eProviderRepository.getFeaturedEServices(
              page: this.page.value);
          break;
        case CategoryFilter.POPULAR:
          _eServices = await _eProviderRepository.getPopularEServices(
              page: this.page.value);
          break;
        case CategoryFilter.RATING:
          _eServices = await _eProviderRepository.getMostRatedEServices(
              page: this.page.value);
          break;
        // case CategoryFilter.AVAILABILITY:
        //   _eServices = await _eProviderRepository.getAvailableEServices(
        //       page: this.page.value);
        //   break;
        default:
          _eServices =
              await _eProviderRepository.getEServices(page: this.page.value);
      }
      print("before checking this");
      if (_eServices.isNotEmpty) {
        SubcategoriesReuse.value = [];
        this.eServices.addAll(_eServices);
        // for (int i = 0; i < eServices.length; i++)
        SubcategoriesReuse.value = Subcategories.where((category) =>
                eServices.any((service) =>
                    service.categories.any((sub) => category.id != sub.id)))
            .toList();
        if (_eServices.length == Subcategories.length) {
          SubcategoriesReuse.value = [];
          print("Sub cat re is $SubcategoriesReuse");
        }

        print("this is comparison $SubcategoriesReuse");
      } else if (_eServices.isEmpty) {
        print("this service is null");
        SubcategoriesReuse.value = Subcategories;
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  void deleteEService(EService eService) async {
    try {
      await _eServiceRepository.delete(eService.id);
      eServices.remove(eService);
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: eService.name + " " + "has been removed".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
